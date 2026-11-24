\set ON_ERROR_STOP on
\encoding UTF8

CREATE SCHEMA IF NOT EXISTS gold;

DROP TABLE IF EXISTS gold.fact_rating, gold.dim_user, gold.dim_movie, gold.dim_date, gold.dim_time;

CREATE TABLE gold.dim_user (
    user_id    INT PRIMARY KEY,
    gender     CHAR(1) NOT NULL CHECK (gender IN ('M','F')),
    zip_code   VARCHAR(10),
    age_group  VARCHAR(20) NOT NULL,
    occupation VARCHAR(50) NOT NULL
);

CREATE TABLE gold.dim_movie (
    movie_id     INT PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    release_year INT,
    genre_name   VARCHAR(200)
);

CREATE TABLE gold.dim_date (
    date_id     INT PRIMARY KEY,
    rated_at    DATE NOT NULL,
    day         INT, month INT, year INT,
    day_of_week INT,
    day_name    VARCHAR(10),
    week        INT,
    month_name  VARCHAR(10),
    quarter     INT
);

CREATE TABLE gold.dim_time (
    time_id     INT PRIMARY KEY,
    rated_time  TIME NOT NULL,
    hour INT, minute INT, second INT,
    time_of_day VARCHAR(10)
);

CREATE TABLE gold.fact_rating (
    rating_id         INT PRIMARY KEY,
    rating            DECIMAL(2,1) NOT NULL,
    rating_count      INT,
    rating_percentage INT,
    user_id  INT NOT NULL REFERENCES gold.dim_user(user_id),
    movie_id INT NOT NULL REFERENCES gold.dim_movie(movie_id),
    date_id  INT NOT NULL REFERENCES gold.dim_date(date_id),
    time_id  INT NOT NULL REFERENCES gold.dim_time(time_id)
);

CREATE INDEX ON gold.fact_rating(user_id);
CREATE INDEX ON gold.fact_rating(movie_id);
CREATE INDEX ON gold.fact_rating(date_id);
CREATE INDEX ON gold.fact_rating(time_id);


INSERT INTO gold.dim_user (user_id, gender, zip_code, age_group, occupation)
SELECT u.user_id, u.gender, u.zip_code,
       COALESCE(a.age_group_name, 'unknown'),
       COALESCE(o.occupation_name, 'unknown')
FROM silver.stg_users u
LEFT JOIN silver.stg_age_group   a ON a.age_group_id  = u.age
LEFT JOIN silver.stg_occupations o ON o.occupation_id = u.occupation_id;


INSERT INTO gold.dim_movie (movie_id, title, release_year, genre_name)
SELECT m.movie_id, m.title, m.release_year,
       STRING_AGG(g.genre_name, ', ' ORDER BY g.genre_name)
FROM silver.stg_movies m
LEFT JOIN silver.stg_genres_movies gm ON gm.movie_id = m.movie_id
LEFT JOIN silver.stg_genres g         ON g.genre_id  = gm.genre_id
GROUP BY m.movie_id, m.title, m.release_year;


INSERT INTO gold.dim_date
SELECT TO_CHAR(d, 'YYYYMMDD')::INT, d::DATE,
       EXTRACT(day FROM d)::INT, EXTRACT(month FROM d)::INT, EXTRACT(year FROM d)::INT,
       EXTRACT(isodow FROM d)::INT, TRIM(TO_CHAR(d, 'Day')),
       EXTRACT(week FROM d)::INT, TRIM(TO_CHAR(d, 'Month')),
       EXTRACT(quarter FROM d)::INT
FROM GENERATE_SERIES(
    (SELECT MIN(rated_at)::DATE FROM silver.stg_ratings),
    (SELECT MAX(rated_at)::DATE FROM silver.stg_ratings),
    INTERVAL '1 day') AS gs(d);

INSERT INTO gold.dim_time
SELECT TO_CHAR(MAKE_INTERVAL(secs => sec), 'HH24MISS')::INT,
       MAKE_TIME(sec / 3600, (sec / 60) % 60, sec % 60),
       sec / 3600, (sec / 60) % 60, sec % 60,
       CASE WHEN sec / 3600 BETWEEN 5  AND 11 THEN 'morning'
            WHEN sec / 3600 BETWEEN 12 AND 17 THEN 'afternoon'
            WHEN sec / 3600 BETWEEN 18 AND 21 THEN 'evening'
            ELSE 'night' END
FROM GENERATE_SERIES(0, 86399) AS gs(sec);

INSERT INTO gold.fact_rating
SELECT r.rating_id,
       r.rating,
       COUNT(*) OVER (PARTITION BY r.movie_id)  AS rating_count,
       ROUND(r.rating * 100.0 / 5)::INT         AS rating_percentage,
       r.user_id, r.movie_id,
       TO_CHAR(r.rated_at, 'YYYYMMDD')::INT     AS date_id,
       TO_CHAR(r.rated_at, 'HH24MISS')::INT     AS time_id
FROM silver.stg_ratings r;