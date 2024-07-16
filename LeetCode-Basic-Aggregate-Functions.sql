/*
602 Not boring movies
Report the movies with an odd-numbered ID and a description that is not "boring".
Return the result table ordered by rating in descending order.
*/
CREATE TABLE Cinema (
    id INT PRIMARY KEY,
    movie VARCHAR(20),
    description VARCHAR(50),
    rating DECIMAL(2,1)
);

-- I added auto increment for convenience
ALTER TABLE Cinema
MODIFY id INT AUTO_INCREMENT;

-- Insert values as in the example - more on https://leetcode.com/
INSERT INTO Cinema(movie, description, rating) VALUES('House card', 'Interesting', 9.1);

-- Solution
SELECT * FROM Cinema
WHERE id%2 = 1 AND description <> 'boring'
ORDER BY rating DESC;

/*
1251 Average Selling Price
Find average selling price for each product. Average_price should
be rounded to 2 decimal places.
*/

CREATE TABLE Prices (
    product_id INT,
    start_date DATE,
    end_date DATE,
    price INT,
    PRIMARY KEY (product_id, start_date, end_date)
);

CREATE TABLE UnitsSold (
    product_id INT,
    purchase_date DATE,
    units INT,
    FOREIGN KEY (product_id) REFERENCES Prices(product_id) ON DELETE CASCADE
);

-- Insert values as in the example - more on https://leetcode.com/
INSERT INTO Prices VALUES(3, '2019-02-21', '2019-03-31', 30);
INSERT INTO UnitsSold VALUES(2, '2019-03-22', 30);

-- Solution
SELECT 
    u.product_id, 
    ROUND(SUM(u.units * p.price) / SUM(u.units), 2) AS average_price
FROM UnitsSold u
JOIN Prices p 
ON u.product_id = p.product_id 
AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY u.product_id;

-- Solution to print 0 when no purchases
SELECT
    p.product_id,
    COALESCE(ROUND(SUM(CASE WHEN u.units IS NOT NULL THEN u.units * p.price ELSE 0 END) / NULLIF(SUM(CASE WHEN u.units IS NOT NULL THEN u.units ELSE 0 END), 0), 2), 0) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
ON p.product_id = u.product_id
AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;

/*
1075. Project Employees I
Report average experience years of all employees
for each project, rounded to 2 digits
*/

CREATE TABLE Project (
    project_id INT,
    employee_id INT,
    PRIMARY KEY (project_id, employee_id)
);

CREATE TABLE Employee_3 (
    employee_id INT PRIMARY KEY,
    name VARCHAR(20),
    experience_years INT NOT NULL
);

-- Add foreign key to Project once Employee_3 is created
ALTER TABLE Project
ADD FOREIGN KEY (employee_id)
REFERENCES Employee_3(employee_id)
ON DELETE CASCADE;

INSERT INTO Employee_3 VALUES
(1, 'Khaled', 3),
(2, 'Ali', 2),
(3, 'John', 1),
(4, 'Doe', 2);

INSERT INTO Project VALUES
(1, 1), (1, 2), (1, 3), (2, 1), (2, 4);

-- Solution
SELECT p.project_id,
ROUND(SUM(e.experience_years)/COUNT(e.employee_id),2)
AS average_years
FROM Project p
JOIN Employee_3 e
ON p.employee_id = e.employee_id
GROUP BY p.project_id;

/*
1633. Percentage of Users Attended a Contest
Find percentage of users registered in each contest
rounded to two decimals. Return result table ordered
by percentage in descending order. In case of a tie,
order it by contest_id in ascending order.
*/

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(10)
);

CREATE TABLE Register (
    contest_id INT,
    user_id INT,
    PRIMARY KEY (contest_id, user_id)
);

INSERT INTO Users VALUES
(6, 'Alice'), (2, 'Bob'), (7, 'Alex');

INSERT INTO Register VALUES
(215,6), (209,2), (208,2), (210,6), (208,6), (209,7),
(209,6), (215,7), (208,7), (210,2), (207,2), (210,7);

-- Solution
SELECT 
    r.contest_id,
    ROUND(COUNT(DISTINCT r.user_id) * 100.0 / (SELECT COUNT(*) FROM Users), 2) AS percentage
FROM  Register r
GROUP BY r.contest_id
ORDER BY percentage DESC, r.contest_id;

-- Solution 2
SELECT
    r.contest_id,
    ROUND(COUNT(DISTINCT r.user_id) * 100.0 / (COUNT(DISTINCT u.user_id)), 2) AS percentage
FROM  Register r
CROSS JOIN Users u
GROUP BY r.contest_id
ORDER BY percentage DESC, r.contest_id;

/*
1211. Queries Quality and Percentage
quality = average of ratio between query rating and its position.
poor query percentage = percentage of all queries with rating less than 3.
Find each query_name, the quality and poor_query_percentage.
Both quality and poor_query_percentage should be rounded to 2 decimal places.
*/

CREATE TABLE Queries (
    query_name VARCHAR(10),
    result VARCHAR(20),
    position INT,
    rating INT
);

INSERT INTO Queries VALUES
('Dog', 'Golden Retriever', 1, 5),
('Dog', 'German Shepherd', 2, 5),
('Dog', 'Mule', 200, 1),
('Cat', 'Shirazi', 5, 2),
('Cat', 'Siamese', 3, 3),
('Cat', 'Sphynx', 7, 4);

-- Solution
SELECT
    query_name,
    ROUND(AVG(rating / position), 2) AS quality,
    ROUND(AVG(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100, 2) AS poor_query_percentage
FROM Queries
WHERE query_name IS NOT NULL
GROUP BY query_name;

/*
1193. Monthly Transactions I
Find for each month and country:
* number of transactions and their total amount,
* number of approved transactions and their total amount.
*/

-- Delete previous Transactions table
DROP TABLE Transactions;

CREATE TABLE Transactions (
    id INT PRIMARY KEY,
    country VARCHAR(15),
    state ENUM("approved", "declined"),
    amount INT,
    trans_date DATE
);

INSERT INTO Transactions VALUES
(121, 'US', 'approved', 1000, '2018-12-18'),
(122, 'US', 'declined', 2000, '2018-12-19'),
(123, 'US', 'approved', 2000, '2019-01-01'),
(124, 'DE', 'approved', 2000, '2019-01-07');

-- Select year and month from trans_date in PopSQL
SELECT
    CONCAT(YEAR(trans_date), '-', LPAD(MONTH(trans_date), 2, '0')) AS month,
    country,
    COUNT(id) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY country, month;

/*
1174. Immediate Food Delivery II

Customer's preferred delivery date is the same as the order date,
then the order is called immediate; otherwise, it is called scheduled.
First order of a customer is the order with earliest order date that the customer made.
It is guaranteed that a customer has precisely one first order.
Find % of immediate orders in the first orders of all customers,
rounded to 2 decimal places.
*/

CREATE TABLE Delivery (
    delivery_id INT UNIQUE,
    customer_id INT,
    order_date DATE,
    customer_pref_delivery_date DATE
);

INSERT INTO Delivery VALUES
(1, 1, '2019-08-01', '2019-08-02'),
(2, 2, '2019-08-02', '2019-08-02'),
(3, 1, '2019-08-11', '2019-08-12'),
(4, 3, '2019-08-24', '2019-08-24'),
(5, 3, '2019-08-21', '2019-08-22'),
(6, 2, '2019-08-11', '2019-08-13'),
(7, 4, '2019-08-09', '2019-08-09');

WITH FirstOrders AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id
),
ImmediateFirstOrders AS (
    SELECT D.customer_id, D.order_date
    FROM Delivery D
    JOIN FirstOrders F
    ON D.customer_id = F.customer_id AND D.order_date = F.first_order_date
    WHERE D.order_date = D.customer_pref_delivery_date
)
SELECT
    ROUND(COUNT(I.customer_id) * 100.0 / COUNT(F.customer_id), 2)
    AS immediate_percentage
FROM
    FirstOrders F
    LEFT JOIN ImmediateFirstOrders I
    ON F.customer_id = I.customer_id;