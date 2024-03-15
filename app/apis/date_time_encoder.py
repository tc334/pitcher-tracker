import json
from json import JSONEncoder
import datetime


class DateTimeEncoder(JSONEncoder):
    # Override the default method
    def default(self, obj):
        if isinstance(obj, (datetime.date, datetime.datetime)):
            return obj.isoformat()


def json_dumps_custom(dict_in, indent=0):
    return json.dumps(dict_in, indent=indent, sort_keys=True, cls=DateTimeEncoder)
