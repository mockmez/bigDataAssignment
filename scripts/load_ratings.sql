-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS books_genres_db;
USE books_genres_db;

-- Create the ratings table with foreign keys and composite primary key
CREATE TABLE IF NOT EXISTS ratings (
    id INT,
    ISBN VARCHAR(20),
    book_rating INT NULL,
    PRIMARY KEY (id, ISBN)  -- Composite primary key (user + book)
    -- FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE,
    -- FOREIGN KEY (ISBN) REFERENCES books(ISBN) ON DELETE CASCADE
);

-- Load data from CSV into ratings table
LOAD DATA INFILE '/var/lib/mysql-files/datasets/ratings.csv' IGNORE
INTO TABLE ratings
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, ISBN, book_rating);
