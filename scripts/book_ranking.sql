USE books_genres_db;

CREATE TABLE ranked_books AS
WITH book_popularity AS (
    SELECT 
        g.genre,
        r.ISBN,
        COUNT(r.id) AS num_readers,
        AVG(r.book_rating) AS avg_rating,
        COUNT(r.id) * AVG(r.book_rating) AS popularity_score
    FROM genres g
    JOIN ratings r ON g.ISBN = r.ISBN
    GROUP BY g.genre, r.ISBN
),
ranked_books AS (
    SELECT 
        genre,
        ISBN,
        popularity_score,
        RANK() OVER (PARTITION BY genre ORDER BY popularity_score DESC) AS rank_position  -- Renamed
    FROM book_popularity
)
SELECT 
    rb.genre,
    rb.rank_position,
    rb.ISBN,
    b.Book_Title,
    rb.popularity_score
FROM ranked_books rb
JOIN books b ON rb.ISBN = b.ISBN
ORDER BY rb.genre, rb.rank_position;
