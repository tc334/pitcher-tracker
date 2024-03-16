from flask import Blueprint, request, jsonify
from .. import db
from .auth_wraps import token_required, admin_only, all_members
from .date_time_encoder import json_dumps_custom

sign_cards_bp = Blueprint('sign_cards', __name__)


@sign_cards_bp.route('/sign_cards', methods=['POST'])
@token_required(all_members)
def add_row(user):
    data_in = request.get_json()

    # Error checking
    base_identifier = "file: " + __name__ + "func: " + add_row.__name__
    if data_in is None:
        return jsonify({"error": "Input json is empty in " + base_identifier}), 400
    # check mandatory keys
    mandatory_keys = ('sign_card_id', 'number', 'pitch_type', 'pitch_height', 'pitch_lateral')
    for key in mandatory_keys:
        if key not in data_in:
            return jsonify({"message": f"Input json missing key '{key}' in " + base_identifier}), 400

    try:
        new_row_id = db.add_via_dict("junction_sign_cards", data_in, returning="id")
        return jsonify({
            "message": "New pitch successfully added to sign card",
            "id": new_row_id
        }), 201
    except:
        message = f"Unable to add sign card"
        print(message)
        print(data_in)
        return jsonify({"error": message}), 400


@sign_cards_bp.route('/sign_cards', methods=['GET'])
@token_required(all_members)
def get_signs(user):
    sign_card_id = request.args.get('sign_card_id')
    number = request.args.get('number')
    try:
        if number is None:
            # this means only sign card is given. return all pitches on that sign card
            table_data = db.get_all_signs_from_card(sign_card_id)
        else:
            # this means both sign card and number are given. return one pitch
            table_data = db.get_sign(sign_card_id, number)
        table_data_json = json_dumps_custom(table_data)
        return table_data_json, 200
    except:
        print(f"Error in get_all_signs_from_one_card")
        return jsonify({"error": "Unable to locate sign"}), 400
