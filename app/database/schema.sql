drop database IF EXISTS pitching_1_0 CASCADE;

create database pitching_1_0;

use pitching_1_0;

CREATE TABLE opponents(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMPTZ(0) DEFAULT localtimestamp() NOT NULL,
    created_by STRING DEFAULT current_user(),
    name STRING NOT NULL,
    birth_year INT
);

CREATE TABLE sign_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMPTZ(0) DEFAULT localtimestamp() NOT NULL,
    created_by STRING DEFAULT current_user(),
    name STRING NOT NULL
);

CREATE TYPE PITCH_TYPE AS ENUM(
    'FAST',
    'CHANGE',
    'CHANGE_ALT',
    'DROP',
    'CURVE',
    'SCREW',
    'RISE'
);

CREATE TABLE junction_sign_cards(
    timestamp TIMESTAMPTZ(0) DEFAULT localtimestamp() NOT NULL,
    created_by STRING DEFAULT current_user(),
    sign_card UUID REFERENCES sign_cards(id),
    number INT,
    pitch_type PITCH_TYPE,
    pitch_height INT CHECK(pitch_height BETWEEN 1 AND 7),
    pitch_lateral INT CHECK(pitch_lateral BETWEEN 1 AND 7),
    CONSTRAINT sign_card_constraint UNIQUE (sign_card, number)
);

CREATE TABLE pitchers(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMPTZ(0) DEFAULT localtimestamp() NOT NULL,
    created_by STRING DEFAULT current_user(),
    first_name STRING NOT NULL,
    last_name STRING
);

CREATE TYPE FIELD_TYPE AS ENUM(
    'TURF',
    'DIRT'
);

CREATE TYPE GAME_TYPE AS ENUM(
    'POOL',
    'BRACKET',
    'LEAGUE',
    'SCRIMMAGE'
);

CREATE TABLE games(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMPTZ(0),
    created_by STRING DEFAULT current_user(),
    opponent UUID REFERENCES opponents(id),
    field_type FIELD_TYPE,
    game_type GAME_TYPE
);

CREATE TYPE HANDED_TYPE AS ENUM(
    'RIGHT',
    'LEFT'
);

CREATE TYPE PITCH_RESULT_TYPE AS ENUM(
    'WILD_PITCH',
    'CALLED_STRIKE',
    'SWINGING_STRIKE',
    'BALL',
    'FOUL',
    'BUNT',
    'HIT_BY_PITCH',
    'HIT_IN_PLAY'
);

CREATE TABLE pitches(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMPTZ(0) DEFAULT localtimestamp() NOT NULL,
    created_by STRING DEFAULT current_user(),
    pitcher UUID REFERENCES pitchers(id),
    game UUID REFERENCES games(id),
    inning INT,
    score_pitcher INT,
    score_opponent INT,
    batter_jersey_number INT,
    batter_handed HANDED_TYPE,
    num_balls INT CHECK(num_balls BETWEEN 0 AND 3),
    num_strikes INT CHECK(num_strikes BETWEEN 0 AND 2),
    num_outs INT CHECK(num_outs BETWEEN 0 AND 2),
    runner_on_first BOOL,
    runner_on_second BOOL,
    runner_on_third BOOL,
    pitch_type PITCH_TYPE,
    pitch_height_called INT CHECK(pitch_height_called BETWEEN 1 AND 7),
    pitch_lateral_called INT CHECK(pitch_lateral_called BETWEEN 1 AND 7),
    result PITCH_RESULT_TYPE,
    pitch_height_actual INT CHECK(pitch_height_actual BETWEEN 1 AND 7),
    pitch_lateral_actual INT CHECK(pitch_lateral_actual BETWEEN 1 AND 7),
    speed INT,
    launch INT CHECK(launch BETWEEN 1 AND 5),
    crush INT CHECK(crush BETWEEN 1 AND 5)
);

CREATE TYPE USER_LEVEL AS ENUM(
    'administrator',
    'user'
);

CREATE SEQUENCE seq_users_id start with 1;
CREATE TABLE users (
  id INT8 NOT NULL DEFAULT nextval('seq_users_id'),
  public_id CHAR(36) NOT NULL,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  email VARCHAR(64) NOT NULL,
  password_hash CHAR(88) NOT NULL,
  level USER_LEVEL NOT NULL DEFAULT 'user',
  status STRING NOT NULL DEFAULT 'active',
  confirmed BOOL NOT NULL DEFAULT false,
  registered_on TIMESTAMP NULL,
  confirmed_on TIMESTAMP NULL,
  CONSTRAINT users_pkey PRIMARY KEY (id ASC),
  INDEX sec_idx_user_email (email ASC)
);

INSERT INTO users(first_name, last_name, email, public_id, password_hash, level, confirmed, confirmed_on)
VALUES ('Tegan', 'Counts', 'tegan.counts@gmail.com', 'fd806fa3-a483-41be-b9b5-339c670ccca2', 'sha256$0Bd49YcPyR36gY3m$fc77db748c4cb1ec6ade8cc08544af604962b6571c2be105fe5181577fc99fcb', 'administrator', 'true', '2024-01-01 00:00:00');
