import datetime

from flask import Blueprint, request, jsonify, current_app, make_response, url_for, render_template
from werkzeug.security import generate_password_hash, check_password_hash
import uuid
import jwt

from .. import db
from .auth_wraps import token_required, admin_only
from app.user_aux.token import generate_confirmation_token
from app.user_aux.email import send_email

users_bp = Blueprint('users', __name__)
table_name = 'users'


@users_bp.route('/login')
def login():
    auth = request.authorization
    if auth and auth.username and auth.password:
        try:
            user = db.get_meta_from_email(auth.username.lower())
        except:
            return make_response("Could not find user with that email", 401, {"WWW-Authenticate": "Basic realm='Login Required'"})

        try:
            if check_password_hash(user["password_hash"], auth.password):
                if user["confirmed"]:
                    if user["status"] == "active":

                        # login successful, send back a JWT
                        token = jwt.encode({
                            "user": user["public_id"],
                            "level": user["level"],
                            "exp": datetime.datetime.utcnow() + datetime.timedelta(days=7),
                            "token_id": str(uuid.uuid4())
                        }, current_app.config["SECRET_KEY"])

                        return jsonify({'token': token})

                    else:
                        return make_response("Your account has been deactivated", 401,
                                             {"WWW-Authenticate": "Basic realm='Login Required'"})
                else:
                    return make_response("Email address not verified. If you just signed up, check your inbox", 401,
                                         {"WWW-Authenticate": "Basic realm='Login Required'"})
            else:
                return make_response("Could not verify password", 401, {"WWW-Authenticate": "Basic realm='Login Required'"})
        except:
            return make_response("Unknown login error", 500, {"WWW-Authenticate": "Basic realm='Login Required'"})
    else:
        return make_response("Login information missing", 401, {"WWW-Authenticate": "Basic realm='Login Required'"})


@users_bp.route('/signup', methods=['POST'])
def signup():
    data_in = request.get_json()  # expecting keys: email, password, first_name, last_name, combo

    # Error checking
    if data_in is None:
        return jsonify({'message': 'No data received'}), 400
    if 'first_name' not in data_in or len(data_in['first_name']) < 2:
        return jsonify({'message': 'First name missing'}), 400
    if 'last_name' not in data_in or len(data_in['last_name']) < 2:
        return jsonify({'message': 'Last name missing'}), 400
    if 'email' not in data_in or len(data_in['email']) < 2:
        return jsonify({'message': 'Email missing'}), 400
    if 'password' not in data_in or len(data_in['password']) < 8:
        return jsonify({'message': 'Password too short'}), 400
    if 'combo' not in data_in or data_in['combo'] != current_app.config["SIGNUP_CODE"]:
        return jsonify({'message': 'Wrong access code'}), 400

    # check for duplicates
    try:
        user_id = db.get_id_from_email(data_in['email'].lower())
        if user_id is not None:
            return jsonify({"message": "Entry " + data_in["email"] + " already exists in " + table_name}), 400
    except:
        message = f"unexpected error looking up user email in signup(); email {data_in['email']}"
        print(message)
        return jsonify({"message": message}), 500

    # append this information to what the user put in
    data_in['public_id'] = str(uuid.uuid4())
    data_in['password_hash'] = generate_password_hash(data_in['password'], method='sha256')
    data_in['registered_on'] = datetime.datetime.now()

    # make email all lower case since they aren't case-sensitive
    data_in['email'] = data_in['email'].lower()

    try:
        db.add_via_dict(table_name, data_in)
    except:
        message = f"unexpected error adding new user to DB in signup(); email {data_in['email']}"
        print(message)
        return jsonify({"message": message}), 500

    # send email to user for them to verify their email address
    try:
        send_confirmation(data_in["email"])
    except:
        message = f"unexpected error sending confirmation email to new user to DB in signup(); email {data_in['email']}"
        print(message)
        return jsonify({"message": message}), 500

    return jsonify({'message': data_in['first_name'] + ' successfully added. Your email needs to be verified before '
                                                       'you can log in. Check your inbox for a '
                                                       'verification link'}), 201


def send_confirmation(email):
    # send email to user for them to verify their email address
    token = generate_confirmation_token(email)
    confirm_url = url_for('main.confirm_email', token=token, _external=True)
    html = render_template('activate.html', confirm_url=confirm_url)
    subject = "Please confirm your email to the Duck Club App"
    send_email(email, subject, html)
    print(f"Just sent confirmation email to {email}")


@users_bp.route('/password_reset_request', methods=['POST'])
def password_reset_request():
    data_in = request.get_json()  # expecting keys: email
    # Error checking
    if data_in is None:
        return jsonify({'message': 'No data received'}), 400
    if 'email' not in data_in:
        return jsonify({'message': 'Email missing'}), 400
    email = data_in["email"].lower()

    # first check to see if this email address exists
    try:
        user_id = db.get_id_from_email(email)
    except:
        message = f"unexpected error looking up user email in password_reset_request(); {email}"
        print(message)
        return jsonify({"message": message}), 500

    if user_id is None:
        # email not found in users table. perhaps fraud? take no further action
        print(f"Password reset request failed. Didn't find {email} in DB")
    else:
        # send email to user for them to reset their password
        token = generate_confirmation_token(email)
        reset_url = url_for('main.reset_password', token=token, _external=True)
        html = render_template('password_reset_email.html', reset_url=reset_url)
        subject = "Password reset to the Duck Club App"
        send_email(email, subject, html)
        print(f"Just sent password reset email to {email}")

    # don't want to indicate to malicious user if email is in our list or not, so same reply for all
    return jsonify({"message": "Request received"}), 200


@users_bp.route('/password_reset', methods=['POST'])
def password_reset():
    public_id = request.form['public_id']
    password = request.form['password']

    if public_id is None or password is None:
        return jsonify({'message': 'No data received'}), 400

    new_dict = {
        'password_hash': generate_password_hash(password, method='sha256')
    }

    try:
        db.update_row(table_name, public_id, new_dict, "public_id")
        return render_template('password_reset_success.html'), 200
    except:
        message = f"unexpected error in password_reset(); {public_id}"
        print(message)
        return jsonify({"message": "Password update failed"}), 500


@users_bp.route('/users/reconfirm/<public_id>', methods=['PUT'])
@token_required(admin_only)
def reconfirm_user(user, public_id):
    # first, get email based on public id
    try:
        email = db.get_email_from_public_id(public_id)
        if email is not None:
            send_confirmation(email)
            return jsonify({"message": f"New confirmation email sent to {email}"}), 200
    except:
        print(f"internal error in reconfirm_user()")
        return jsonify({"message": "internal error"}), 500

    return jsonify({"error": f"Unsuccessful reconfirm attempt"}), 400
