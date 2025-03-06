
CREATE DATABASE IF NOT EXISTS books_genres_db;
USE books_genres_db;


CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL PRIMARY KEY,
    location VARCHAR(255) NULL,
    age INT NULL
);


LOAD DATA INFILE '/var/lib/mysql-files/datasets/Users.csv' IGNORE
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, location, age);