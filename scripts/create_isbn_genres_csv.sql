USE books_genres_db;

SELECT ISBN, genres
INTO OUTFILE '/var/lib/mysql-files/isbn_genres.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
FROM isbn_genres;