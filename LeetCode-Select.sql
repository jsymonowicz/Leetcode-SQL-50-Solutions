/*
1757 Recyclable and Low Fat Products
Find ids of products that are both low fat and recyclable.
*/

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    low_fats ENUM ('Y', 'N'),
    recyclable ENUM ('Y', 'N')
);

-- Add autoincrement to product_id to make input of values easier
ALTER TABLE products
MODIFY product_id INT AUTO_INCREMENT;

-- Insert values as in the example - more on https://leetcode.com/
INSERT INTO products VALUES(0, 'Y', 'N');
INSERT INTO products(low_fats, recyclable) VALUES('N', 'N');

-- Solution
SELECT product_id FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';
-----------------------------------------

/*
584. Find Customer Referee
Find names of customer that are not referred by customer with id = 2.
*/

CREATE TABLE Customer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20),
    referee_id INT
);

-- Insert values as in the example - more on https://leetcode.com/
INSERT INTO Customer(name, referee_id) VALUES('Mark', 2);

-- Solution
SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id <> 2;
-----------------------------------------

/*
595. Big Countries
A country is big if:
* it has an area >= 3000000 km2
or
* it has a population >= 25000000.
Write a solution to find name, population, area of big countries.
*/

CREATE TABLE World (
    name VARCHAR(20),
    continent VARCHAR(20),
    area INT,
    population INT,
    gdp BIGINT,
    PRIMARY KEY (name)
);

-- Insert values as in the example - more on https://leetcode.com/
INSERT INTO World VALUES('Angola', 'Africa', 1246700, 20609294, 100990000000);

-- Solution
SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;

/*
1148 Article Views I
Find all authors that viewed >= 1 of their own articles.
Return result table sorted by id in ascending order.
*/

CREATE TABLE Views (
    article_id INT,
    author_id INT,
    viewer_id INT,
    view_date DATE
);

-- Insert values as in the example
INSERT INTO Views VALUES
(1, 3, 5, '2019-08-01'),
(1, 3, 6, '2019-08-02'),
(2, 7, 7, '2019-08-01'),
(2, 7, 6, '2019-08-02'),
(4, 7, 1, '2019-07-22'),
(3, 4, 4, '2019-07-21'),
(3, 4, 4, '2019-07-21');

-- Solution
SELECT DISTINCT author_id as id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;
-----------------------------------------

/*
1683 Invalid Tweets
Find IDs of invalid tweets (num of chars in content > 15)
*/

CREATE TABLE Tweets (
    tweet_id INT,
    content VARCHAR(20),
    PRIMARY KEY (tweet_id)
);

-- Extended content to 40 chars to fit Tweet 2
ALTER TABLE Tweets
MODIFY content VARCHAR(40);

-- Insert values as in the example
INSERT INTO Tweets VALUES
(1, 'Vote for Biden'),
(2, 'Let us make America great again!');

-- Solution
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;