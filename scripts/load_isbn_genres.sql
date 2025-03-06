USE books_genres_db;


CREATE TABLE IF NOT EXISTS genres (
    ISBN VARCHAR(20),
    genre VARCHAR(50),
    PRIMARY KEY (ISBN, genre),
    CONSTRAINT fk_isbn FOREIGN KEY (ISBN) REFERENCES books(ISBN)
);


LOAD DATA INFILE '/var/lib/mysql-files/datasets/m2m_isbn_genres.csv'
INTO TABLE genres
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;