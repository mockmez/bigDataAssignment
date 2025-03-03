-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS books_genres_db;

-- Use the database
USE books_genres_db;

-- Create the books table if it doesn't exist
CREATE TABLE IF NOT EXISTS books (
    ISBN VARCHAR(20) NOT NULL PRIMARY KEY,
    Book_Title VARCHAR(255) NULL,
    Book_Author VARCHAR(255) NULL,
    Year_Of_Publication INT NULL,
    Publisher VARCHAR(255) NULL,
    Image_URL_S VARCHAR(255) NULL,
    Image_URL_M VARCHAR(255) NULL,
    Image_URL_L VARCHAR(255) NULL
);

LOAD DATA INFILE '/var/lib/mysql-files/datasets/Books.csv' IGNORE
INTO TABLE books
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ISBN, Book_Title, Book_Author, Year_Of_Publication, Publisher, Image_URL_S, Image_URL_M, Image_URL_L);