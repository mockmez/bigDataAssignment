USE books_genres_db;


CREATE TABLE temp_user_mapping (
    original_user_id VARCHAR(255),
    new_user_id INT
);


SET @max_id = (SELECT MAX(id) FROM users);


INSERT INTO users (id, location, age)
SELECT 
    (@row_number := @row_number + 1) + @max_id AS new_id,
    NULL,
    NULL
FROM 
    (SELECT DISTINCT user_id FROM genres) AS distinct_users
CROSS JOIN (SELECT @row_number := 0) AS rn;

INSERT INTO temp_user_mapping (original_user_id, new_user_id)
SELECT 
    distinct_users.user_id AS original_user_id,
    (@row_number := @row_number + 1) + @max_id AS new_user_id
FROM 
    (SELECT DISTINCT user_id FROM genres) AS distinct_users
CROSS JOIN (SELECT @row_number := 0) AS rn;


INSERT INTO ratings (id, ISBN, book_rating)
SELECT
    t.new_user_id AS id,  -- Use the new user ID from temp_user_mapping
    g.isbn,               -- Use the ISBN from genres
    g.rating * 2 AS book_rating  -- Double the rating (scale 0-5 -> 0-10)
FROM
    genres g
JOIN
    temp_user_mapping t ON g.user_id = t.original_user_id;  -- Map user_id to new_id