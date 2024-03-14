from db_mgr_cockroach import DbManagerCockroach


class DBAPI():
    def __init__(self):
        self.db = DbManagerCockroach()

    def init_app(self, db_url, db_name):
        self.db.init_app(db_url)
        self.db.select_db(db_name)

    def add_via_dict(self, table, dict_in, returning=None):
        return self.db.add_row_by_dict(table, dict_in, returning=returning)

    def update_row(self, table_name, id_value, update_dict):
        self.db.update_row(table_name, id_value, update_dict)

    def get_id_from_name(self, table, name):
        results = self.db.read_custom(
            f"SELECT id FROM {table} "
            f"WHERE name='{name}'"
        )

        if results and len(results) == 1:
            return results[0][0]
        else:
            raise Exception(f"Error in get_id_from_name(). Name {name} not found in table {table}")

    def get_public_id_from_email(self, email):
        results = self.db.read_custom(
            f"SELECT public_id "
            f"FROM users "
            f"WHERE email = '{email}'"
        )

        if results and len(results) == 1:
            return results[0][0]
        else:
            raise Exception("Error in get_public_id_from_email. No (or too many) results returned´")

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
            raise Exception("Error in get_status_from_email. No (or too many) results returned")
