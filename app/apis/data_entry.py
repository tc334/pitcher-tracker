from flask import Blueprint, request, jsonify
from .. import db
from .auth_wraps import token_required, admin_only, all_members
from date_time_encoder import json_dumps_custom

data_entry_bp = Blueprint('data_entry', __name__)


@data_entry_bp.route('/data_entry/<table_name>', methods=['POST'])
@token_required(all_members)
def add_row(user, table_name):
    data_in = request.get_json()

    # Error checking
    base_identifier = "file: " + __name__ + "func: " + add_row.__name__
    if data_in is None:
        return jsonify({"error": "Input json is empty in " + base_identifier}), 400

    try:
        new_row_id = db.add_via_dict(table_name, data_in, returning="id")
        return jsonify({
            "message": data_in["name"] + " successfully added to " + table_name,
            "id": new_row_id
        }), 201
    except:
        message = f"Unable to add row to table {table_name}"
        print(message)
        return jsonify({"error": message}), 400


@data_entry_bp.route('/data_entry', methods=['GET'])
@token_required(all_members)
def get_data(user):
    table_name = request.args.get('table_name')
    row_id = request.args.get('row_id')
    try:
        if row_id is None:
            table_data = db.get_all(table_name)
        else:
            table_data = db.get_one(table_name, row_id)
        table_data_json = json_dumps_custom(table_data)
        return table_data_json, 200
    except:
        message = f"Error in get_all_rows from table {table_name}"
        print(message)
        return jsonify({"error": message}), 400


@data_entry_bp.route('/data_entry/<table_name>/<row_id>', methods=['PUT'])
@token_required(all_members)
def update_row(user, table_name, row_id):
    data_in = request.get_json()
    try:
        db.update_row(table_name, row_id, data_in)
        return jsonify({'message': 'Successful update'}), 200
    except:
        message = f"Error updating row {row_id} from table {table_name}"
        print(message)
        return jsonify({"error": message}), 400


@data_entry_bp.route('/data_entry/<tale_name>/<row_id>', methods=['DELETE'])
@token_required(admin_only)
def del_row(user, table_name, row_id):
    try:
        db.del_row(table_name, row_id)
        return jsonify({'message': 'Successful removal'}), 200
    except:
        message = f"Error deleting row {row_id} from table {table_name}"
        print(message)
        return jsonify({"error": message}), 400
