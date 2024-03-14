from os import environ

SECRET_KEY = environ.get('SECRET_KEY')
SIGNUP_CODE = environ.get('SIGNUP_CODE')

COCKROACH_URL = environ.get('COCKROACH_URL')
DB_NAME = environ.get('DB_NAME')

SENDGRID_API_KEY = environ.get('SENDGRID_API_KEY')
