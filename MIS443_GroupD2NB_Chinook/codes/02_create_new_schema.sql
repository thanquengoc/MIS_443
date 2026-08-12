-- =============================================================================
-- MIS 443 - 02_create_new_schema.sql
-- Database : mis443_chinook
-- Run after  : 01_load_source_data.sql
-- =============================================================================

CREATE SCHEMA new_chinook;

--- /// CREATE TABLES /// ---
CREATE TABLE new_chinook.artist (
    artist_id INTEGER      PRIMARY KEY,
    name      VARCHAR(120) NOT NULL
);

CREATE TABLE new_chinook.album (
    album_id  INTEGER      PRIMARY KEY,
    title     VARCHAR(160) NOT NULL,
    artist_id INTEGER      NOT NULL,
    CONSTRAINT fk_album_artist
        FOREIGN KEY (artist_id) REFERENCES new_chinook.artist (artist_id)
        ON DELETE RESTRICT
);

CREATE TABLE new_chinook.genre (
    genre_id INTEGER      PRIMARY KEY,
    name     VARCHAR(120) NOT NULL
);

CREATE TABLE new_chinook.media_type (
    media_type_id INTEGER      PRIMARY KEY,
    name          VARCHAR(120) NOT NULL
);

CREATE TABLE new_chinook.playlist (
    playlist_id INTEGER      PRIMARY KEY,
    name        VARCHAR(120) NOT NULL
);

CREATE TABLE new_chinook.employee (
    employee_id INTEGER     PRIMARY KEY,
    last_name   VARCHAR(20) NOT NULL,
    first_name  VARCHAR(20) NOT NULL,
    title       VARCHAR(30),
    reports_to  INTEGER     REFERENCES new_chinook.employee (employee_id),
    birth_date  DATE,
    hire_date   DATE,
    address     VARCHAR(70),
    city        VARCHAR(40),
    state       VARCHAR(40),
    country     VARCHAR(40),
    postal_code VARCHAR(10),
    phone       VARCHAR(24),
    fax         VARCHAR(24),
    email       VARCHAR(60)
);

CREATE TABLE new_chinook.track (
    track_id      INTEGER       PRIMARY KEY,
    name          VARCHAR(200)  NOT NULL,
    album_id      INTEGER       REFERENCES new_chinook.album (album_id),
    media_type_id INTEGER       NOT NULL REFERENCES new_chinook.media_type (media_type_id),
    genre_id      INTEGER       REFERENCES new_chinook.genre (genre_id),
    composer      VARCHAR(220),
    milliseconds  INTEGER       NOT NULL CHECK (milliseconds > 0),
    bytes         INTEGER,
    unit_price    NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE new_chinook.customer (
    customer_id    INTEGER     PRIMARY KEY,
    first_name     VARCHAR(40) NOT NULL,
    last_name      VARCHAR(20) NOT NULL,
    company        VARCHAR(80),
    address        VARCHAR(70),
    city           VARCHAR(40),
    state          VARCHAR(40),
    country        VARCHAR(40),
    postal_code    VARCHAR(10),
    phone          VARCHAR(24),
    fax            VARCHAR(24),
    email          VARCHAR(60) NOT NULL,
    support_rep_id INTEGER     REFERENCES new_chinook.employee (employee_id)
);

CREATE TABLE new_chinook.playlist_track (
    playlist_id INTEGER NOT NULL REFERENCES new_chinook.playlist (playlist_id) ON DELETE CASCADE,
    track_id    INTEGER NOT NULL REFERENCES new_chinook.track (track_id),
    PRIMARY KEY (playlist_id, track_id)
);

CREATE TABLE new_chinook.invoice (
    invoice_id          INTEGER       PRIMARY KEY,
    customer_id         INTEGER       NOT NULL REFERENCES new_chinook.customer (customer_id),
    invoice_date        TIMESTAMP     NOT NULL,
    billing_address     VARCHAR(70),
    billing_city        VARCHAR(40),
    billing_state       VARCHAR(40),
    billing_country     VARCHAR(40),
    billing_postal_code VARCHAR(10),
    total               NUMERIC(10,2) NOT NULL CHECK (total >= 0)
);

CREATE TABLE new_chinook.invoice_line (
    invoice_line_id INTEGER       PRIMARY KEY,
    invoice_id      INTEGER       NOT NULL REFERENCES new_chinook.invoice (invoice_id) ON DELETE CASCADE,
    track_id        INTEGER       NOT NULL REFERENCES new_chinook.track (track_id),
    unit_price      NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    quantity        INTEGER       NOT NULL CHECK (quantity > 0)
);
