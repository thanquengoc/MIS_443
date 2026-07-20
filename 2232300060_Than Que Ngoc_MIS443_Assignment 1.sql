/*
STUDENT NAME: Than Que Ngoc
STUDENT ID: 2232300060
LAB NAME: LAB 1 (Assignment 1)
DATE: 4 July 2026
*/

-- QUESTION: Please create SQL statements to fetch the first 20 rows of each table
SELECT * FROM public.closest_dealerships LIMIT 20;
SELECT * FROM public.countries LIMIT 20;
SELECT * FROM public.customer_sales LIMIT 20;
SELECT * FROM public.customer_sales_copy LIMIT 20;
SELECT * FROM public.customer_survey LIMIT 20;
SELECT * FROM public.customers LIMIT 20;
SELECT * FROM public.dealerships LIMIT 20;
SELECT * FROM public.emails LIMIT 20;
SELECT * FROM public.products LIMIT 20;
SELECT * FROM public.public_transportation_by_zip LIMIT 20;
SELECT * FROM public.sales LIMIT 20;
SELECT * FROM public.salespeople LIMIT 20;
SELECT * FROM public.top_cities_data LIMIT 20;

-- Q1: which table is empty?
SELECT * FROM public.countries LIMIT 20;
-- ANSWER: The "countries" table is empty (0 rows returned)

-- Q2: which table has fewer than 20 records?
SELECT * FROM public.countries LIMIT 20;
SELECT * FROM public.products LIMIT 20;
-- ANSWER: The "countries" table has fewer than 20 records (0 rows returned)
--         The "products" table has fewer than 20 records (only 12 rows returned)
