import random
import time
import json
import traceback
from typing import Callable

import psycopg2
# from tenacity import retry, wait_exponential, stop_after_attempt, retry_if_exception_type


def reconnect(f: Callable):
    def wrapper(storage, *args, **kwargs):
        if not storage.connected():
            print(f"DB-MGR-CDB: DB not connected when {f} called. Attempting to connect")
            if storage.connect():
                storage.select_db_without_execute()
                print(f"    Successful reconnection inside reconnect wrapper")
            else:
                print(f"    DB connection failed inside reconnect wrapper")

        return f(storage, *args, **kwargs)
    return wrapper


class DbManagerCockroach:

    def __init__(self):
        self.db_url = None
        self.conn = None

    def init_app(self, db_url):
        # capture inputs in member variables
        self.db_url = db_url

        # trying to stagger wsgi workers
        # time.sleep(round(random.random()*5))

        # initial server connection
        if self.connect():
            self.print_version()

    # ***********************************************************************************
    # The following functions are DB connection maintenance
    def connected(self):
        return self.conn and self.conn.closed == 0

    def connect(self):
        print(f"DB-MGR-CDB: connect()")

        try:
            self.close()
            self.conn = psycopg2.connect(self.db_url)
            return True

        except psycopg2.Error as e:
            print(f"DB-MGR-CDB: Error connecting to Cockroach DB: {e}")
            return False

    def close(self):
        if self.connected():
            try:
                self.conn.close()
            except Exception:
                pass

        self.conn = None
    # ***********************************************************************************

    #@retry(stop=stop_after_attempt(2), wait=wait_exponential(),
    #       retry=retry_if_exception_type(psycopg2.OperationalError))
    @reconnect
    def execute(self, sql_str, value_tuple=None, expecting_return=False):
        with self.conn:
            with self.conn.cursor() as cur:
                try:
                    if value_tuple:
                        cur.execute(sql_str, value_tuple)
                    else:
                        cur.execute(sql_str)
                    if expecting_return:
                        ret_val = cur.fetchall()
                except psycopg2.Error as e:
                    print(f"DB-MGR-CDB: Error in db_mgr_cockroach:execute()")
                    print(f"    sql_str: {sql_str}")
                    print(f"    value_tuple: {value_tuple}")
                    print(f"    pgerror={e.pgerror}")
                    print(f"    pgcode={e.pgcode}")
                    traceback.print_exc()
                    # print(f"DB-MGR-CDB: Closing database connection in response to failed execute")
                    # self.close()
                    raise Exception("DB-MGR-CDG execution error")

        if expecting_return:
            return ret_val
        else:
            return None

    # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    # The methods in this section are intended to be called by an external user
    def print_version(self):
        rows = self.execute("SELECT version()", expecting_return=True)
        if rows:
            for i, row in enumerate(rows):
                print(f"row{i}:{row}")

    def add_row(self, table, columns, values, returning=None):
        # table should be a string
        # columns and values should both be tuples of the same length
        # if using SQL arrays for column i, values[i] should be a list
        a = ["%s"] * len(columns)
        sql = f"INSERT INTO {table} ({','.join(columns)}) VALUES ({','.join(a)})"
        if returning:
            sql += f" RETURNING {returning}"

        expecting_return = returning is not None

        exe_rtn = self.execute(sql, values, expecting_return=expecting_return)

        if expecting_return:
            if exe_rtn and len(exe_rtn) == 1:
                return expecting_return[0][0]
            else:
                return

    def add_row_by_dict(self, table, dict_in, returning=None):
        # if input dict contains any dictionaries within it, they need to be stringified
        for key in dict_in.keys():
            if isinstance(dict_in[key], dict):
                dict_in[key] = json.dumps(dict_in[key])

        columns = tuple(dict_in.keys())
        values = tuple([dict_in[key] for key in columns])
        return self.add_row(table, columns, values, returning=returning)

    def read_custom(self, custom_query):
        return self.execute(custom_query, expecting_return=True)

    def write_custom(self, sql_str):
        return self.execute(sql_str)

    def update_row(self, table_name, id_value, update_dict, id_field="id"):
        set_str = ""
        data_list = []
        for key in update_dict:
            if not key == id_field:
                set_str = set_str + key + "=%s,"
                if update_dict[key] is None:
                    data_list.append(None)
                else:
                    data_list.append(str(update_dict[key]))
        # id goes at the end b/c it's associated with the WHERE
        data_list.append(id_value)

        my_sql_insert_query = f"UPDATE {table_name} SET {set_str[:-1]} WHERE {id_field}=%s"

        self.execute(my_sql_insert_query, value_tuple=tuple(data_list))

    def del_row(self, table_name, row_id, id_field="id"):
        sql_delete_query = f"DELETE FROM {table_name} WHERE {id_field} = '{row_id}'"
        return self.execute(sql_delete_query)

    # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
