
names & student numbers
4 questions + link to git repo
Use illustrations i your report

Books.csv: 
- ISBN
- Book-Title
- Book-Author
- Year-Of-Publication
- Publisher
- Image-URL-S
- Image-URL-M
- Image-URL-L
Ratings.csv
- User-ID
- ISBN
- Book-Rating
Users.csv
- User-ID
- Location
- Age
books_and_genres.csv
- \#
- title
- text
- genres

### 1) Briefly introduce the dataset of your project. Specifically, what are the big data challenges in terms of volume and variety?
We have a total of 4 files (10.5MB, 21.6MB, 69.9MB, 3.36GB) storing data such as IDs, ages, Locations, Titles, full texts, ratings etc.

volume: to compare to our system specifications & capabilities
variety: data format
show a runnable...??????

### 2) What is the ultimate objective of your data analysis tasks? (value)
Understand book genres preferences by age.

### 3) What are the small data analysis tasks to achieve the objective?
1. reformat titles: all-lowercase => shell
2. reformat age: replace with category => shell
3. reformat texts: huffman tree => shell
4. join on titles, ISBN, User-ID => SQL
5. group by age category => SQL
6. group by genre => SQL
7. compute average of ratings within each group => SQL
8. keep biggest => SQL

(1 task ~= 1 bash command/SQl statement)
highlight computationally expensive tasks

### 4) How to use the big data technologies (MapReduce on Hadoop or Spark) to improve these computationally expensive tasks? (tentative answers ok)
Computationally expensive = computation or storage






I don't remember why I write that down
```bash
docker exec namenode stop-yarn.sh
docker exec namenode stop-dfs.sh
docker exec namenode start-dfs.sh
docker exec namenode start-yarn.sh
```