from db_mgr_cockroach import DbManagerCockroach


class DBAPI():
    def __init__(self):
        self.db = DbManagerCockroach()

    def init_app(self, db_url, db_name):
        self.db.init_app(db_url)
        self.db.select_db(db_name)

    def add_via_dict(self, table, dict_in, returning=None):
        return self.db.add_row_by_dict(table, dict_in, returning=returning)

    def get_id_from_name(self, table, name):
        results = self.db.read_custom(
            f"SELECT id FROM {table} "
            f"WHERE name='{name}'"
        )

        if results and len(results) == 1:
            return results[0][0]
        else:
            raise Exception(f"Error in get_id_from_name(). Name {name} not found in table {table}")
