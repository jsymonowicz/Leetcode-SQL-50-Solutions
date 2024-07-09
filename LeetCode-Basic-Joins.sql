/*
1378 Replace Employee ID with the Unique Identifier
Write a solution to show the unique ID of each user
If a user does not have a unique ID replace just show null
*/

CREATE TABLE Employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20)
);

CREATE TABLE EmployeeUNI (
    id INT AUTO_INCREMENT,
    unique_id INT PRIMARY KEY,
    FOREIGN KEY(id) REFERENCES Employees(id) ON DELETE CASCADE
);

-- Insert values as in example - more on https://leetcode.com/
INSERT INTO Employees VALUES(3, 'Jonathan');
INSERT INTO EmployeeUNI VALUES(90,3);

-- Solution
SELECT EmployeeUNI.unique_id, Employees.name
FROM EmployeeUNI
RIGHT JOIN Employees
ON EmployeeUNI.id = Employees.id;

/*
1068 Product Sales Analysis I
Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
Return the resulting table in any order.
*/

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(20)

);

CREATE TABLE Sales (
    sale_id INT,
    product_id INT,
    year INT,
    quantity INT,
    price INT,
    PRIMARY KEY (sale_id, year),
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE
);

-- Insert values as in example - more on https://leetcode.com/
INSERT INTO Product VALUES(300, 'Samsung');
INSERT INTO Sales VALUES(7, 200, 2011, 15, 9000);

-- Solution
SELECT Product.product_name, Sales.year, Sales.price
FROM Sales
JOIN Product
ON Sales.product_id = Product.product_id;

/*
1581 Customer who visited but did not make any transations
Find IDs of users who visited without making any transactions
and number of times they made these types of visits.
*/

CREATE TABLE Visits (
    visit_id INT UNIQUE,
    customer_id INT
);

CREATE TABLE Transactions (
    transaction_id INT UNIQUE,
    visit_id INT,
    amount INT,
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id) ON DELETE SET NULL
);

-- Insert values as in example - more on https://leetcode.com/
INSERT INTO Visits VALUES(8, 54);
INSERT INTO Transactions VALUES(13, 2, 970);

-- Solution
SELECT v.customer_id, COUNT(v.visit_id) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t 
ON v.visit_id = t.visit_id
WHERE t.visit_id IS NULL
GROUP BY v.customer_id;

/*
197 Rising Temperature
Find Id with higher temps compared to its previous dates.
*/

CREATE TABLE Weather (
    id INT UNIQUE,
    recordDate DATE,
    temperature INT
);

-- Insert values as in example - more on https://leetcode.com/
INSERT INTO Weather VALUES(4, '2015-01-04', 30);

-- Solution
SELECT w1.id
FROM Weather w1
JOIN Weather w2 ON w1.recordDate = DATE_ADD(w2.recordDate, INTERVAL 1 DAY)
WHERE w1.temperature > w2.temperature;

/*
1661 Average Time of Process per Machine
Find machine_id with its average time as processing_time, rounded to 3 decimal places.
*/

CREATE TABLE Activity (
    machine_id INT,
    process_id INT,
    activity_type ENUM('start', 'end'),
    timestamp FLOAT,
    PRIMARY KEY (machine_id, process_id, activity_type)
);

-- Insert values as in example
INSERT INTO Activity VALUES
(0, 0, 'end', 1.520),
(0, 1,'start', 3.140),
(0, 1,'end', 4.120),
(1, 0,'start', 0.550),
(1, 0,'end', 1.550),
(1, 1,'start', 0.430),
(1, 1,'end', 1.420),
(2, 0,'start', 4.100),
(2, 0,'end', 4.512),
(2, 1,'start', 2.500),
(2, 1,'end', 5.000);

-- Solution
SELECT a1.machine_id, ROUND(AVG(a2.timestamp - a1.timestamp),3) AS processing_time
FROM Activity a1
JOIN Activity a2 ON a1.process_id = a2.process_id 
                AND a1.machine_id = a2.machine_id 
                AND a1.activity_type = 'start' 
                AND a2.activity_type = 'end'
GROUP BY a1.machine_id;

/*
577 Employee Bonus
Report name and bonus of each employee with bonus < 1000
*/

CREATE TABLE Employee_1 (
    empID INT UNIQUE,
    name VARCHAR(20),
    supervisor INT,
    salary INT
);

CREATE TABLE Bonus (
    empID INT UNIQUE,
    bonus INT,
    FOREIGN KEY (empID) REFERENCES Employee_1(empID) ON DELETE SET NULL
);

-- Insert values as in example
INSERT INTO Employee_1 VALUES
(3, 'Brad', null, 4000),
(1, 'John', 3, 1000),
(2, 'Dan', 3, 2000),
(4, 'Thomas', 3, 4000);

INSERT INTO Bonus VALUES
(2, 500),
(4, 2000);

-- Solution
SELECT e.name, b.bonus
FROM Employee_1 e
LEFT JOIN Bonus b
ON e.empID = b.empID
WHERE b.bonus < 1000 OR b.bonus IS NULL;

/*
1280. Students and Examinations
Find number of times each student attended each exam.
Return result table ordered by student_id and subject_name.
*/

CREATE TABLE Students (
    student_id INT,
    student_name VARCHAR(20),
    PRIMARY KEY(student_id)
);

CREATE TABLE Subjects (
    subject_name VARCHAR(20) PRIMARY KEY
);

CREATE TABLE Examinations (
    student_id INT,
    subject_name VARCHAR(20),
    FOREIGN KEY (subject_name) REFERENCES Subjects(subject_name) ON DELETE SET NULL
);

-- Forgot to add student_id as foreign key
ALTER TABLE Examinations
ADD CONSTRAINT fk_student
FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE SET NULL;

-- Insert values as in example
INSERT INTO Students VALUES
(1, 'Alice'),
(2, 'Bob'),
(13, 'John'),
(6, 'Alex');

INSERT INTO Subjects VALUES
('Math'),('Physics'),('Programming');

INSERT INTO Examinations VALUES
(1, 'Math'),
(1, 'Physics'),
(1, 'Programming'),
(2, 'Programming'),
(1, 'Physics'),
(1, 'Math'),
(13, 'Math'),
(13, 'Programming'),
(13, 'Physics'),
(2, 'Math'),
(1, 'Math');

-- Solution
SELECT 
    s.student_id, 
    s.student_name, 
    subj.subject_name, 
    COUNT(e.subject_name) AS attended_exams
FROM 
    Students s
-- Ensures that every student is paired with every subject:
CROSS JOIN 
    Subjects subj
-- Ensures 0 for student-subject pair when no matching records in Examinations:
LEFT JOIN 
    Examinations e 
ON 
    s.student_id = e.student_id AND subj.subject_name = e.subject_name
GROUP BY 
    s.student_id, s.student_name, subj.subject_name
ORDER BY 
    s.student_id, subj.subject_name;