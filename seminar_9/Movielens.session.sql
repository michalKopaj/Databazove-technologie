CREATE DATABASE movielens_elt;
-- teraz sa prepni na databázu movielens_elt (v psql: \c movielens_elt, v pgAdmin/SQLTools vyber túto DB)

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.age_group (
    id           TEXT,
    name         TEXT,
    _source_file TEXT        DEFAULT 'age_group.csv',
    _loaded_at   TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.genres (
    id           TEXT,
    name         TEXT,
    _source_file TEXT        DEFAULT 'genres.csv',
    _loaded_at   TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.genres_movies (
    id           TEXT,
    movie_id     TEXT,
    genre_id     TEXT,
    _source_file TEXT        DEFAULT 'genres_movies.csv',
    _loaded_at   TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.movies (
    id           TEXT,
    title        TEXT,
    release_year TEXT,
    _source_file TEXT        DEFAULT 'movies.csv',
    _loaded_at   TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.occupations (
    id           TEXT,
    name         TEXT,
    _source_file TEXT        DEFAULT 'occupations.csv',
    _loaded_at   TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.ratings (
    id           TEXT,
    user_id      TEXT,
    movie_id     TEXT,
    rating       TEXT,
    rated_at     TEXT,
    _source_file TEXT        DEFAULT 'ratings.csv',
    _loaded_at   TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.users (
    id            TEXT,
    age           TEXT,
    gender        TEXT,
    occupation_id TEXT,
    zip_code      TEXT,
    _source_file  TEXT        DEFAULT 'users.csv',
    _loaded_at    TIMESTAMPTZ DEFAULT now()
);