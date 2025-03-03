USE books_genres_db;

CREATE TABLE genres (
    id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    text LONGBLOB NOT NULL,  -- Compressed book text
    genres TEXT NOT NULL
);

LOAD DATA INFILE '/var/lib/mysql-files/datasets/books_and_genres.csv' 
INTO TABLE genres
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS  -- Skip header row
(id, title, @text, genres)  -- Read the CSV columns
SET text = COMPRESS(@text);  -- Compress the text column before inserting
