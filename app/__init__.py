from flask import Flask
from flask_cors import CORS
from flask_mail import Mail
from .database.db_api import DBAPI
import os


# instance of databases
db = DBAPI()
queue = None
mail = None


def create_app():
    app = Flask(__name__)
    CORS(app)

    app.config.from_pyfile(os.path.join('..', 'settings.py'))

    db.init_app(
        app.config["COCKROACH_URL"],
        app.config["DB_NAME"],
    )

    global mail
    mail = Mail(app)
    app.config['MAIL_USE_TLS'] = False
    app.config['MAIL_USE_SSL'] = True

    from .views import main
    app.register_blueprint(main)
    from . import apis
    app.register_blueprint(apis.data_entry_bp)
    app.register_blueprint(apis.users_bp)
    app.register_blueprint(apis.sign_cards_bp)

    return app
