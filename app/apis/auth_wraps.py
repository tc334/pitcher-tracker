from functools import wraps
from flask import request, jsonify, current_app
import jwt
from .. import db


def token_required(member_level_test):
    def actual_decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            if current_app.config["BYPASS_AUTH"]:
                # this allows app dev & test without worrying about auth & JWTs
                ret_val = f(None, *args, **kwargs)
                return ret_val

            if 'x-access-token' in request.headers:
                token = request.headers['x-access-token']
                if token:
                    try:
                        jwt_data = jwt.decode(token, current_app.config["SECRET_KEY"], algorithms=["HS256"])
                    except jwt.exceptions.InvalidTokenError as e:
                        return jsonify({'error': 'Token is invalid! ' + repr(e)}), 401
                    try:
                        current_user = db.get_meta_from_public_id(jwt_data['user'])
                    except:
                        return jsonify({'error': 'User not found'}), 403
                    if member_level_test(current_user["level"]):
                        ret_val = f(current_user, *args, **kwargs)
                        return ret_val
                    else:
                        return jsonify({'error': 'User not authorized'}), 403
            return jsonify({'error': 'Token is missing'}), 401
        return wrapper
    return actual_decorator


def admin_only(level):
    if level == "administrator":
        return True
    else:
        return False


def all_members(level):
    return True
