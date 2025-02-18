**Group Project Plan(Ungraded)**

**Tamoghno Banerjee – 22205922**  
**Alice Karatchentzeff de Vienne – 22707181**

Question 1  
   
Briefly introduce the dataset of your project. Specifically, what are the big data challenges in terms of volume and variety?  
What kind of code snippets would be expected for this question?

Our dataset consists of 4 CSV files.

1. Books.csv  
2. books\_and\_genres.csv  
3. Users.csv  
4. Ratings.csv

Which are described respectively,

1. Schema consists of a ISBN, Book-Title, Book-Author, Year-Of-Publication, Publisher. Along with these, there are 3 more fields, Image-URL-S, Image-URL-M and Image-URL-L which are URLs to the small, medium and large covers of their books respectively. The last three fields introduce some non-structuredness into our dataset. This CSV file is 73.29 MB in size and is imported onto a table in our MySQL database.  
2. Schema consists of an index, title and the entire text of the book, as well as the genres of the book provided in a string. Clearly, when loaded onto MySQL initially it is present as a string and some processing is required to be able to work with and store it more efficiently. The alternative would be to drop the “text” column as it isn’t used for the purpose of this project. The CSV file is 3.61 GB due to the entire text of all the books being present.  
3. Schema consists of a user index, location of the user as well as their age. This file has 279,000 entries for a size of 11.02 MB. This is imported quite easily onto our database.  
4. Schema consists of user IDs along with ISBN code and rating. This implies that this table is representative of users’ ratings of some books. This file comes to about 22.63 MB. From the inherent nature of this table, it is easy to realise that this table is representative of a many-to-many relationship. Where many users can provide ratings for many books. This table thus requires the enforcement of referential integrity with two tables, Users.csv and Books.csv.

Here are some of the challenges in terms of volume and variety,

1. The dataset in total is over 3 GB mainly because of the books\_and\_genres.csv file. It takes a lot of effort and time to import this dataset on MySQL due to its sheer **volume**. Therefore, a lot of careful pre-processing steps are required to load and retrieve data to and from the database in the most efficient way possible.  
2. The datasets Books.csv, Users.csv and Ratings.csv are from a different source as compared to books\_and\_genres.csv. This means that the books provided in books\_and\_genres.csv possibly will be different from those provided in Books.csv. This means a considerable **volume** of data, now unworkable, will need to be carefully dropped from the database. A similar situation happens with Users.csv, as many entries have no associated age and will be unusable.  
3. The books\_and\_genres.csv file contains book genres in a JSON-like formatted string. Since MySQL does not handle JSON-like strings efficiently for indexing and querying, we need to normalize the data by creating an atomic representation of genres. This will allow books to be properly indexed and queried by their genres. As there are a hundred genres and each book can theoretically belong to all of them, this presents us with a problem of **volume** and the JSON-like strings present themselves as a problem of **variety**.  
4. Referential integrity plays an important role in our database. Establishing this integrity(here via foreign keys) introduces a challenge of data **variety**. The ISBN is used to identify the books between datasets Books.csv, Users.csv and Ratings.csv. When loaded onto a database it is important that we can query information regarding the same book from different tables using foreign keys.  
5. As previously mentioned, there are 100 genres and each book can theoretically belong to all of them. In order to be able to query books on their genres, one-hot encoding would be a very inefficient approach. The schema would include more than a hundred fields which would make the database extremely slow. Another alternate, reasonable, approach would be to try a junction table highlighting the many-to-many relationship between books and genres. In this scenario we would be introducing **variety** to help solve a problem of **volume**.  
6. Finally, it is important to realize that it would be very inefficient to have the entire text of books in cells. It would be a much better idea to serialize the data and store it in the modified format(BLOB for example). However, because of this, working with our data becomes more challenging. Here, once again we are sacrificing **volume** for **variety**.  
   

Our above analysis of problems as well as some suggested solutions to counter them shows that for efficiency and optimization it is better to trade-off the challenge of **volume** for the challenge of **variety**. 

Question 2  
What kind of code snippets would be expected for this question?

We aim to understand the preferences of different ages to different book genres. In order to achieve this, we do the following:

1. Categorize ages into different groups. Let’s say we have 0-10, 10 \- 20, 20 \- 30 and so on.  
2. Aggregate genre preferences by each group. We can do this by getting the count of the number of ratings per genre per aggregate age group as well as average rating per genre per aggregate age group. This provides us two metrics to find popularity, number of ratings as well as the value of the ratings.  
3. Finally, we decided on an empirical formula to decide the popularity of different age groups to different genres by multiplying the two metrics, average rating and number of ratings. This gives us the statistic of expected popularity.

Question 3

The small data analysis tasks we aim to achieve the objective are:

1. Reformat all the book titles to lowercase. BASH Script.

```
mlr --csv put '$title=tolower($title)' books.csv > books_lowercase.csv
```

2. Load the CSV into the database correctly. MySQL Script for loading books\_and\_genres.csv 

   First we generate the table with the correct schema.

```
CREATE TABLE books (
	book_index INT PRIMARY KEY,
	book_title VARCHAR(255),
	book_genres VARCHAR(500),
	book_text BIGBLOB
);


```

Next we proceed to load our CSV file

```
LOAD DATA INFILE '/path/to/books.csv'
INTO TABLE books
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(book_index, book_title, book_genres, @book_text)
SET book_text = COMPRESS(@book_text);
```

This task possibly is the most expensive computationally and also for storage. 

3. Only including books which are present in all tables

In order to do this, we perform a join between Books and books\_and\_genres

```
CREATE TABLE BooksAndGenres_Filtered AS
SELECT BG.*
FROM BooksAndGenres BG
JOIN Books B ON BG.title = B.Book_Title;
```

   
Now BooksAndGenres\_Filtered only contains the books present in books. We can rename our table to its original name after this operation. This operation is computationally expensive since so many books are getting removed and not present in both tables.

4. Establishing referential integrity of our database.

This is done by creating foreign keys correctly.  
First we ensure that our primary keys are correctly set in all tables. Below, we set a few primary keys.

```
ALTER TABLE Books ADD PRIMARY KEY (ISBN);
ALTER TABLE Users ADD PRIMARY KEY (user_index);
ALTER TABLE books ADD CONSTRAINT books_title_pk PRIMARY KEY (Book_Title);
```

Next, we establish foreign keys correctly

```
/*Foreign key between books_and_genres and books based on title*/

ALTER TABLE books_and_genres
ADD CONSTRAINT fk_books_genres_title FOREIGN KEY (title)
REFERENCES books(Book_Title) ON DELETE CASCADE;

/*Foreign key relationship of rating to books and users*/

ALTER TABLE Ratings
ADD CONSTRAINT fk_ratings_books
FOREIGN KEY (isbn) REFERENCES Books(ISBN)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Ratings
ADD CONSTRAINT fk_ratings_users
FOREIGN KEY (user_id) REFERENCES Users(user_index)
ON DELETE CASCADE ON UPDATE CASCADE;
```

5. Creating our junction table.

For this we are using BASH since it is not possible to extract strings in SQL. This is computationally expensive since our books\_and\_genres.csv file is quite large. This command performs I/O on the file system and reads the entire CSV in a sequential manner. As the file grows large (3GB+), the I/O becomes the bottleneck, making the operation computationally expensive.

```
mlr --csv --ifs ',' --ofs ',' \
	put 'for (g in sub($Genres, "[{}]", "") | split(g, ", ")) { emit {Title: $Title, Genre: g} }' \
	books_and_genres.csv > junction.csv
```

Finally, as demonstrated before, we can load the table, remove books that are not present in other tables, and establish a foreign key for the title. These tasks as similar to tasks described before and therefore also are computationally expensive.

6. Categorizing age groups

```
ALTER TABLE Users ADD COLUMN age_group VARCHAR(20);

UPDATE Users
SET age_group =
	CASE
    	WHEN age BETWEEN 0 AND 12 THEN 'Children'
    	WHEN age BETWEEN 13 AND 18 THEN 'Teen'
    	WHEN age BETWEEN 19 AND 25 THEN 'Young Adult'
    	WHEN age BETWEEN 26 AND 40 THEN 'Adult'
    	WHEN age BETWEEN 41 AND 60 THEN 'Middle-Aged'
    	ELSE 'Senior'
	END;
```

7. Creating a table to show how different age groups have different preferences towards different genres.  
 


```
CREATE TABLE Genre_Popularity ( age_group VARCHAR(50), genre_name VARCHAR(100), total_ratings INT, avg_rating DECIMAL(5, 2), popularity DECIMAL(10, 2) );
```

8. We count the number of ratings per genre per age group as well as find the average rating for each of the genres. This is also computationally expensive. There are 5 joins happening here for a large amount of data which makes this operation computational intensive. There is also sorting involved here by age group and then further by total ratings which increases complexity.

```
SELECT U.age_group, G.genre_name, COUNT(R.rating) AS total_ratings, AVG(R.rating) AS avg_rating
FROM Ratings R
JOIN Users U ON R.user_id = U.user_index
JOIN Books B ON R.isbn = B.ISBN
JOIN Book_Genres BG ON B.ISBN = BG.book_id
JOIN Genres G ON BG.genre_id = G.genre_id
GROUP BY U.age_group, G.genre_name
ORDER BY U.age_group, total_ratings DESC;
```

9. In order to find our “popularity” measure for which we defined our above two metrics, we can include the following in our query

```
SELECT (COUNT(R.rating) * AVG(R.rating)) AS popularity
```

Question 4

How to use the big data technologies (MapReduce on Hadoop or Spark) to improve these computationally expensive tasks?

```
LOAD DATA INFILE '/path/to/books.csv'
INTO TABLE books
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(book_index, book_title, book_genres, @book_text)
SET book_text = COMPRESS(@book_text);
```

This task was described as the most computationally intensive task. This is because of row by row non-parallelized processing, compression overhead as well as single-threaded execution.

When we use Hadoop File System,

1. We can read CSV data in parallel across multiple nodes.  
2. Apply compression on the book\_text column.  
3. Store the output in a structured format.

When we use Spark, this gets the job done even better because,

1. We can load CSVs in parallel (faster I/O).  
2. Process text compression in-memory.  
3. Write directly to Parquet/ORC (structured format).

```
CREATE TABLE BooksAndGenres_Filtered AS
SELECT BG.*
FROM BooksAndGenres BG
JOIN Books B ON BG.title = B.Book_Title;
```

   
This is another computationally expensive task.

Hadoop distributes data processing across multiple nodes. 

1. It stores CSVs on HDFS for distributed processing.  
2. It uses MapReduce to perform the join efficiently.  
3. Writes the result as a compressed Parquet file (fast retrieval).  
4. Processes chunks of data instead of whole tables.

In this case, MapReduce would roughly take the form:  
\- Mapper: combine every row from BookesAndGenres with every row from Books.  
\- Reducer: retain rows for which the titles are the same.

Spark is even faster because it processes data in-memory instead of reading from disk repeatedly.

1. It allows for parallelized join execution across nodes.  
2. In-memory processing  
3. Efficient columnar storage reduces query time.

We mentioned the BASH script as computationally expensive,

```
mlr --csv --ifs ',' --ofs ',' \
	put 'for (g in sub($Genres, "[{}]", "") | split(g, ", ")) { emit {Title: $Title, Genre: g} }' \
	books_and_genres.csv > junction.csv
```

Hadoop splits the dataset into smaller chunks and processes them in parallel across multiple machines, reducing the overall time it takes to perform the transformation.

Hadoop works with HDFS (Hadoop Distributed File System), where large datasets are stored across multiple machines. This allows for scalable storage and faster I/O during processing.

Spark processes data in-memory (RAM), which is significantly faster than writing intermediate data to disk, as Hadoop does. Spark divides the input data into partitions and processes them in parallel across multiple worker nodes. Each partition processes a chunk of data independently.

Finally, this is one of the most computationally expensive tasks

```
SELECT U.age_group, G.genre_name, COUNT(R.rating) AS total_ratings, AVG(R.rating) AS avg_rating
FROM Ratings R
JOIN Users U ON R.user_id = U.user_index
JOIN Books B ON R.isbn = B.ISBN
JOIN Book_Genres BG ON B.ISBN = BG.book_id
JOIN Genres G ON BG.genre_id = G.genre_id
GROUP BY U.age_group, G.genre_name
ORDER BY U.age_group, total_ratings DESC;
```

In Hadoop MapReduce, the computation is distributed across multiple machines, allowing the task to be parallelized, which significantly reduces the time taken for computation.

In this case, MapReduce would roughly take the form:  
\- Mapper: create the mapping (age, genre) \-\> rating for every row produced by the joins.  
\- Reducer: combine them into rating count and average.

However, Spark offers several advantages over Hadoop for this kind of task due to its in-memory processing and optimized execution engine.