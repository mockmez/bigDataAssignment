USE books_genres_db;

CREATE TABLE genres (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255),
    isbn VARCHAR(255),
    rating INT,
    authors TEXT,
    description TEXT,
    genres TEXT,
    pages INT,
    title TEXT,
    publishYear INT,
    publishMonth INT
);

CREATE TEMPORARY TABLE temp_genres (
    user_id VARCHAR(255),
    isbn VARCHAR(255),
    rating INT,
    authors TEXT,
    description TEXT,
    genres TEXT,
    pages INT,
    title TEXT,
    publishYear INT,
    publishMonth INT
);

LOAD DATA INFILE '/var/lib/mysql-files/datasets/merged_books_ratings.csv' 
IGNORE INTO TABLE temp_genres
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(user_id, isbn, rating, authors, description, genres, pages, title, publishYear, publishMonth);

INSERT INTO genres (user_id, isbn, rating, authors, description, genres, pages, title, publishYear, publishMonth)
SELECT tg.user_id, tg.isbn, tg.rating, tg.authors, tg.description, tg.genres, tg.pages, tg.title, tg.publishYear, tg.publishMonth
FROM temp_genres tg
JOIN books b ON tg.isbn = b.isbn;

-- Drop the temporary table (optional)
DROP TEMPORARY TABLE temp_genres;
