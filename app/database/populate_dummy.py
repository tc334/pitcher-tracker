import datetime

from dotenv import dotenv_values
import json
from json import JSONEncoder

from db_api import DBAPI


class DateTimeEncoder(JSONEncoder):
    # Override the default method
    def default(self, obj):
        if isinstance(obj, (datetime.date, datetime.datetime)):
            return obj.isoformat()


def json_dumps_custom(dict_in, indent=0):
    return json.dumps(dict_in, indent=indent, sort_keys=True, cls=DateTimeEncoder)


def add_opponents(db):
    db.add_via_dict("opponents", {
        "name": "Prosper Pride 13",
        "birth_year": 2013
    })

    db.add_via_dict("opponents", {
        "name": "Prosper Pride 14",
        "birth_year": 2014
    })

    db.add_via_dict("opponents", {
        "name": "Hotshots (Carr)",
        "birth_year": 2013
    })


def add_pitchers(db):
    db.add_via_dict("pitchers", {
        "first_name": "Madison",
        "last_name": "Counts"
    })

    db.add_via_dict("pitchers", {
        "first_name": "Leighton",
        "last_name": "Sahyouni"
    })


def add_sign_card(db):
    sign_card_id = db.add_via_dict("sign_cards", {"name": "Card A"}, returning="id")
    num = 100

    # inside fastball
    num += 1
    db.add_via_dict("junction_sign_cards", {
        "sign_card": sign_card_id,
        "number": num,
        "pitch_type": 'FAST',
        "pitch_height": 4,
        "pitch_lateral": 3,
    })

    # outside drop ball
    num += 1
    db.add_via_dict("junction_sign_cards", {
        "sign_card": sign_card_id,
        "number": num,
        "pitch_type": 'DROP',
        "pitch_height": 2,
        "pitch_lateral": 5,
    })

    # low change up
    num += 1
    db.add_via_dict("junction_sign_cards", {
        "sign_card": sign_card_id,
        "number": num,
        "pitch_type": 'CHANGE',
        "pitch_height": 2,
        "pitch_lateral": 4,
    })


def add_games(db):
    opponent_id = db.get_id_from_name("opponents", "Hotshots (Carr)")
    db.add_via_dict(
        "games",
        {
            "timestamp": "2024-03-03 11:30:00-06:00",
            "opponent": opponent_id,
            "field_type": "TURF",
            "game_type": "POOL"
        }
    )


if __name__ == '__main__':
    config = dotenv_values('../../.env')

    db = DBAPI()
    db.init_app(db_url=config["COCKROACH_URL"], db_name=config["DB_NAME"])

    add_pitchers(db)
    add_opponents(db)
    add_sign_card(db)
    add_games(db)

    data = db.get_all("games")
    for row in data:
        print(json_dumps_custom(row, indent=4))
