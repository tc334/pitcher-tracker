# from db_mgr_cockroach import DbManagerCockroach
import db_mgr_cockroach as DBC


class DBAPI:
    def __init__(self):
        self.db = DBC.DbManagerCockroach()

    def init_app(self, db_url, db_name):
        self.db.init_app(db_url)
        self.db.select_db(db_name)

    def add_via_dict(self, table, dict_in, returning=None):
        ret_val = self.db.add_row_by_dict(table, dict_in, returning=returning)
        if returning is not None and len(returning) == 1:
            return ret_val[0]
        else:
            return ret_val

    def update_row(self, table_name, id_value, update_dict):
        self.db.update_row(table_name, id_value, update_dict)

    def delete_row(self, table_name, row_id):
        self.db.del_row(table_name, row_id)

    def get_column_names(self, table_name):
        results = self.db.read_custom(
            f"SELECT column_name "
            f"FROM information_schema.columns "
            f"WHERE table_schema = 'public' "
            f"AND table_name='{table_name}'"
        )
        return [row[0] for row in results]

    def get_one(self, table_name, row_id, id_col_name="id"):
        results = self.db.read_custom(
            f"SELECT * "
            f"FROM {table_name} "
            f"WHERE {id_col_name} = '{row_id}'"
        )
        if results and len(results) == 1:
            col_names = self.get_column_names(table_name)

            # format from list of tuples to single of dictionary
            return {col_names[i_col]: col_val for (i_col, col_val) in enumerate(results[0])}
        else:
            message = f"Error in get_one(). Row {id_col_name}={row_id} not found in table {table_name}"
            print(message)
            raise Exception(message)

    def get_all(self, table_name, limit=50):
        results = self.db.read_custom(
            f"SELECT * "
            f"FROM {table_name} "
            f"ORDER BY timestamp DESC "
            f"LIMIT {limit}"
        )

        col_names = self.get_column_names(table_name)

        # format from list of tuples to list of dictionary
        return [{col_names[i_col]: col_val for (i_col, col_val) in enumerate(row)} for row in results]

    def get_id_from_name(self, table, name):
        results = self.db.read_custom(
            f"SELECT id FROM {table} "
            f"WHERE name='{name}'"
        )

        if results and len(results) == 1:
            return results[0][0]
        else:
            message = f"Error in get_id_from_name(). Name {name} not found in table {table}"
            print(message)
            raise Exception(message)

    def get_public_id_from_email(self, email):
        results = self.db.read_custom(
            f"SELECT public_id "
            f"FROM users "
            f"WHERE email = '{email}'"
        )

        if results and len(results) == 1:
            return results[0][0]
        else:
            message = "Error in get_public_id_from_email. No (or too many) results returned´"
            print(message)
            raise Exception(message)

    def get_status_from_email(self, email):
        results = self.db.read_custom(
            f"SELECT id, confirmed "
            f"FROM users "
            f"WHERE email = '{email}'"
        )

        if results and len(results) == 1:
            return {
                "id": results[0][0],
                "confirmed": results[0][1]
            }
        else:
            message = "Error in get_status_from_email. No (or too many) results returned"
            print(message)
            raise Exception(message)

    def get_meta_from_public_id(self, public_id):
        results = self.db.read_custom(
            f"SELECT id, level, public_id "
            f"FROM users "
            f"WHERE public_id='{public_id}' LIMIT 1"
        )

        if results and len(results) == 1:
            return {
                "id": results[0][0],
                "level": results[0][1],
                "public_id": results[0][2]
            }
        else:
            message = "Error in get_meta_from_public_id. No (or too many) results returned"
            print(message)
            raise Exception(message)

    def get_meta_from_email(self, email):
        results = self.db.read_custom(
            f"SELECT public_id, password_hash, level, confirmed, status "
            f"FROM users "
            f"WHERE email = '{email}'"
        )

        if results and len(results) == 1:
            return {
                "public_id": results[0][0],
                "password_hash": results[0][1],
                "level": results[0][2],
                "confirmed": results[0][3],
                "status": results[0][4]
            }
        else:
            message = "Error in get_meta_from_email. No (or too many) results returned"
            print(message)
            raise Exception(message)

    def get_id_from_email(self, email):
        results = self.db.read_custom(
            f"SELECT id "
            f"FROM users "
            f"WHERE email = '{email}'")

        if results and len(results) == 1:
            return results[0][0]
        return None

    def get_email_from_public_id(self, public_id):
        results = self.db.read_custom(
            f"SELECT email "
            f"FROM users "
            f"WHERE public_id='{public_id}'"
        )

        if results and len(results) == 1:
            return results[0][0]
        else:
            message = "Error in get_email_from_public_id. No (or too many) results returned"
            print(message)
            raise Exception(message)

    def get_all_signs_from_card(self, sign_card_id):
        results = self.db.read_custom(
            f"SELECT number, pitch_type, pitch_height, pitch_lateral "
            f"FROM junction_sign_cards "
            f"WHERE sign_card='{sign_card_id}' "
            f"ORDER BY number"
        )

        return [{
            "number": row[0],
            "pitch_type": row[1],
            "pitch_height": row[2],
            "pitch_lateral": row[3]
        } for row in results]

    def get_sign(self, sign_card_id, number):
        results = self.db.read_custom(
            f"SELECT pitch_type, pitch_height, pitch_lateral "
            f"FROM junction_sign_cards "
            f"WHERE sign_card='{sign_card_id}' "
            f"AND number='{number}' "
        )

        if results and len(results) == 1:
            return {
                "pitch_type": results[0][1],
                "pitch_height": results[0][2],
                "pitch_lateral": results[0][3]
            }
        else:
            message = "Error in get_ign. No (or too many) results returned"
            print(message)
            raise Exception(message)
