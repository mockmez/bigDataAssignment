-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS books_genres_db;
USE books_genres_db;

-- Create the users table
CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL PRIMARY KEY,
    location VARCHAR(255) NULL,  -- Fixed incorrect type
    age INT NULL
);

-- Load data from CSV into users table
LOAD DATA INFILE '/var/lib/mysql-files/datasets/Users.csv' IGNORE
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, location, age);