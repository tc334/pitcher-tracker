import datetime

from flask import Blueprint, render_template, url_for

from app.user_aux.token import confirm_token
from . import db

main = Blueprint('main', __name__)


@main.route('/')
def main_index():
    return "Hello World, from the real app!"


@main.route('/confirm/<token>')
def confirm_email(token):
    try:
        email = confirm_token(token)
    except:
        print('The confirmation link is invalid or has expired.')
        return 'The confirmation link is invalid or has expired.'

    try:
        user = db.get_status_from_email(email)
    except:
        print(f"Unable to locate user with {email} in confirm_email method.")
        return "Lookup of the user's email failed"

    if user["confirmed"]:
        print("Account already confirmed")
        return "Account already confirmed. Please login"
    else:
        user_new = {
            "confirmed": True,
            "confirmed_on": datetime.datetime.now(),
            "status": "active"
        }
        try:
            db.update_row("users", user["id"], user_new)
        except:
            print("Exception caught when updating user status in DB")
            return "Error updating user status in DB"

    return render_template('activation_success.html')


@main.route('/reset_password/<token>')
def reset_password(token):
    try:
        email = confirm_token(token)
    except:
        return 'The password reset link is invalid or has expired.'

    try:
        pid = db.get_public_id_from_email(email)
    except:
        return "Lookup of the user's email failed"

    return render_template('password_reset_page.html', public_id=pid)
