
/*
MIS 443 - FINAL EXAM - Q2
DATE: 25/03/2026

STUDENT NAME: Than Que Ngoc
STUDENT ID: 2232300060
*/

/*

Question 1 – Database Setup (10 marks)

Using pgAdmin & PostgreSQL:

(a) Create a database named yourfullname. Then load all Northwind tables into this schema. (5 marks)
Use file "Northwind.sql"

(b) Create a new table called students inside schema exam with the following columns:

Column	Requirement
studentid	5-digit number, Primary Key
fullname	Required
email	Must be unique

Insert your own information into the table. (5 marks)

Then you can check your database before continuing.
*/
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' 
ORDER BY table_name, ordinal_position;


--(b) Create table students
CREATE SCHEMA exam;

CREATE TABLE exam.students (
    studentid VARCHAR(5) PRIMARY KEY,
    fullname  VARCHAR(100) NOT NULL,
    email     VARCHAR(100) UNIQUE NOT NULL
);

--(c) Insert your own record
INSERT INTO exam.students (studentid, fullname, email)
VALUES ('00060', 'Than Que Ngoc', 'ngoc.thanque.bbs22@eiu.edu.vn');

-- (d) Verify the result
SELECT * FROM exam.students;


-- Question 2: Write an SQL query to find the top 5 customers who placed the highest number of orders.
SELECT customer_id, COUNT(*) AS total_orders FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 5;


-- Question 3: Write an SQL query to display a list of orders and the customers who made them. Sort by order date (newest first)
SELECT orders.order_id, orders.order_date, customers.company_name FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
ORDER BY orders.order_date DESC;

-- Question 4: Northwind management wants to identify large product movements to better plan inventory and logistics. Write an SQL query to display orders where a product was purchased in large quantity (more than 99 units in a single order).
SELECT orders.order_id, orders.order_date, products.product_name, order_details.quantity FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
WHERE order_details.quantity > 99
ORDER BY orders.order_id;

-- Question 5: Northwind management wants to evaluate the delivery performance of each shipping partner. Write an SQL query to calculate the average delivery time (in days) for each shipper. Delivery time = shipped_date – order_date
SELECT shippers.company_name, AVG(orders.shipped_date - orders.order_date) AS avg_delivery_days FROM orders
JOIN shippers ON shippers.shipper_id = orders.ship_via
WHERE orders.shipped_date IS NOT NULL
GROUP BY shippers.shipper_id, shippers.company_name
ORDER BY avg_delivery_days DESC;


-- Question 6: Northwind wants to identify the most active customers (customers who place orders most frequently) to target retention campaigns. Write an SQL query to rank customers based on their total number of orders (highest = rank 1). Customers with the same number of orders must have the same rank.
SELECT customers.customer_id,
       customers.company_name,
       COUNT(orders.order_id) AS total_orders,
       RANK() OVER (ORDER BY COUNT(orders.order_id) DESC) AS customer_rank
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.company_name
ORDER BY customer_rank;
