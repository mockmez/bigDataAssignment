USE books_genres_db;

DELETE FROM books
WHERE NOT EXISTS (
    SELECT 1
    FROM genres g
    WHERE g.isbn = books.isbn
);
