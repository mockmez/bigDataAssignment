
CREATE DATABASE IF NOT EXISTS books_genres_db;
USE books_genres_db;


CREATE TABLE IF NOT EXISTS ratings (
    id INT,
    ISBN VARCHAR(20),
    book_rating INT NULL,
    PRIMARY KEY (id, ISBN)  -- Composite primary key (user + book)
);


LOAD DATA INFILE '/var/lib/mysql-files/datasets/ratings.csv' IGNORE
INTO TABLE ratings
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, ISBN, book_rating);
