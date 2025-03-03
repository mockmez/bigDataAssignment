USE books_genres_db;

DELETE FROM ratings
WHERE id NOT IN (SELECT id FROM users)
OR ISBN NOT IN (SELECT ISBN FROM books);

-- Add foreign key constraint for the 'id' column referencing 'users(id)'
ALTER TABLE ratings
ADD CONSTRAINT fk_ratings_users
FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE;

-- Add foreign key constraint for the 'ISBN' column referencing 'books(ISBN)'
ALTER TABLE ratings
ADD CONSTRAINT fk_ratings_books
FOREIGN KEY (ISBN) REFERENCES books(ISBN) ON DELETE CASCADE;