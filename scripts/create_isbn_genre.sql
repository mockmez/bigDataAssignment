USE books_genres_db;

CREATE TABLE isbn_genres (
    ISBN VARCHAR(20) PRIMARY KEY,
    genres TEXT
);

INSERT INTO isbn_genres (ISBN, genres)
SELECT DISTINCT ISBN, genres
FROM genres;