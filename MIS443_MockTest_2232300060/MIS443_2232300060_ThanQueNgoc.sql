/*
===============================================================================
MIS 443 - FINANCE ANALYSIS - SQL SKELETON
PostgreSQL | Duration: 90 minutes | Total: 100 marks

STUDENT ID : 2232300060
FULL NAME  : Than Que Ngoc
GITHUB URL : https://github.com/thanquengoc/MIS_443/tree/main/MIS443_MockTest_2232300060
===============================================================================
*/

/*
BUSINESS SCENARIO AND DATASET

The database represents a retail bank that manages customers, branches,
accounts, and account transactions. Managers use it to monitor customer value,
account balances, branch performance, and transaction activity.

- customers: one row per customer;
- branches: one row per bank branch;
- accounts: each account belongs to one customer and one branch;
- transactions: each transaction belongs to one account.

Positive account balances represent funds held by customers. Negative Credit
Card balances represent amounts owed. Positive transaction amounts are credits
and negative transaction amounts are debits.

SUBMISSION REMINDER
Submit the completed SQL file, Word report, and ERD screenshot on Moodle, and
upload the same files to your accessible personal GitHub repository.
*/

/*
QUESTION 1 - DATABASE SETUP (10 marks)

Create a PostgreSQL database using your full name in lowercase, without spaces
or Vietnamese diacritics. Connect to it and execute
MIS443_Finance_PostgreSQL.sql. Confirm that customers, branches, accounts, and
transactions are available in the public schema. (10 marks)
*/

-- Expected result after loading the supplied data:
-- accounts     | 15
-- branches     | 15
-- customers    | 6
-- transactions | 15


/*
QUESTION 2 - CUSTOMER AND ACCOUNT OVERVIEW (10 marks)

(a) The Customer Service Manager needs a contact list of customers living in
New York. Display customer_id, full_name, and city, sorted by customer_id.
(5 marks)
*/
-- Your answer here
SELECT customer_id, first_name || ' ' || last_name AS full_name, city
FROM customers
WHERE city = 'New York'
ORDER BY customer_id;


-- Expected result:
-- 1 | John Doe | New York
-- 2 | Jane Doe | New York


/*
(b) Management needs to confirm the size of the account portfolio. Calculate
the total number of accounts and name the result total_accounts. (5 marks)
*/
-- Your answer here
SELECT COUNT(*) AS total_accounts FROM accounts;

-- Expected result: 15


/*
QUESTION 3 - ACCOUNT BALANCE ANALYSIS (20 marks)

(a) The Finance Manager wants to monitor funds held in checking accounts.
Calculate their total balance and name the result total_checking_balance.
(10 marks)
*/
-- Your answer here
SELECT SUM(balance) AS total_checking_balance
FROM accounts
WHERE account_type = 'Checking';

-- Expected result: 31000.00


/*
(b) The Los Angeles Regional Manager wants to compare customer portfolios.
For each customer living in Los Angeles, display customer_id, full_name, and
total_balance across all account types. Sort by total_balance descending.
(10 marks)
*/
-- Your answer here
SELECT customers.customer_id,
       customers.first_name || ' ' || customers.last_name AS full_name,
       SUM(accounts.balance) AS total_balance
FROM customers
JOIN accounts ON customers.customer_id = accounts.customer_id
WHERE customers.city = 'Los Angeles'
GROUP BY customers.customer_id, customers.first_name, customers.last_name
ORDER BY total_balance DESC;

-- Expected result:
-- 5 | Michael Lee   | 60000.00
-- 6 | Jennifer Wang | 15000.00


/*
QUESTION 4 - BRANCH AND CUSTOMER PORTFOLIO ANALYSIS (20 marks)

(a) Senior management wants to identify the branch with the highest average
account balance. Display branch_id, branch_name, city, and average_balance.
Return all branches tied for the highest average and round to two decimals.
(10 marks)
*/

-- Your answer here
SELECT branch_id, branch_name, city, average_balance
FROM (
    SELECT branches.branch_id, branches.branch_name, branches.city,
           ROUND(AVG(accounts.balance), 2) AS average_balance,
           RANK() OVER (ORDER BY AVG(accounts.balance) DESC) AS balance_rank
    FROM branches
    JOIN accounts ON branches.branch_id = accounts.branch_id
    GROUP BY branches.branch_id, branches.branch_name, branches.city
) ranked_branches
WHERE balance_rank = 1;

-- Expected result:
-- 14 | North Beach | San Francisco | 30000.00


/*
(b) A relationship manager wants to identify the customer who owns the single
account with the highest current balance. Display customer_id, full_name,
account_id, account_type, and balance. Include ties if any. (10 marks)
*/

-- Your answer here
SELECT customer_id, full_name, account_id, account_type, balance
FROM (
    SELECT customers.customer_id,
           customers.first_name || ' ' || customers.last_name AS full_name,
           accounts.account_id, accounts.account_type, accounts.balance,
           RANK() OVER (ORDER BY accounts.balance DESC) AS balance_rank
    FROM accounts
    JOIN customers ON accounts.customer_id = customers.customer_id
) ranked_accounts
WHERE balance_rank = 1;
-- Expected result:
-- 5 | Michael Lee | 10 | Savings | 50000.00


/*
QUESTION 5 - CUSTOMER VALUE AND ACTIVITY (20 marks)

(a) The Customer Relationship Manager wants to identify the most active
customer based on the total number of transactions across all their accounts.
Display customer_id, full_name, and total_transactions. Include ties.
(10 marks)
*/

-- Your answer here
SELECT customer_id, full_name, total_transactions
FROM (
    SELECT customers.customer_id,
           customers.first_name || ' ' || customers.last_name AS full_name,
           COUNT(transactions.transaction_id) AS total_transactions,
           RANK() OVER (ORDER BY COUNT(transactions.transaction_id) DESC) AS transaction_rank
    FROM customers
    JOIN accounts ON customers.customer_id = accounts.customer_id
    JOIN transactions ON accounts.account_id = transactions.account_id
    GROUP BY customers.customer_id, customers.first_name, customers.last_name
) ranked_customers
WHERE transaction_rank = 1
ORDER BY customer_id;

-- Expected result:
-- 2 | Jane Doe      | 4
-- 4 | Alice Johnson | 4


/*
(b) The Deposit Manager wants to identify the customer with the highest total
balance across Checking and Savings accounts only. Display customer_id,
full_name, and total_deposit_balance. Include ties. (10 marks)
*/

-- Your answer here
SELECT customer_id, full_name, total_deposit_balance
FROM (
    SELECT customers.customer_id,
           customers.first_name || ' ' || customers.last_name AS full_name,
           SUM(accounts.balance) AS total_deposit_balance,
           RANK() OVER (ORDER BY SUM(accounts.balance) DESC) AS deposit_rank
    FROM customers
    JOIN accounts ON customers.customer_id = accounts.customer_id
    WHERE accounts.account_type IN ('Checking', 'Savings')
    GROUP BY customers.customer_id, customers.first_name, customers.last_name
) ranked_customers
WHERE deposit_rank = 1;
-- Expected result:
-- 5 | Michael Lee | 60000.00


/*
QUESTION 6 - ADVANCED FINANCE ANALYSIS (20 marks)

(a) Management wants to identify the branch with the highest total balance
across all account types. Display branch_id, branch_name, and total_balance.
Include ties. (10 marks)
*/

-- Your answer here
SELECT branch_id, branch_name, total_balance
FROM (
    SELECT branches.branch_id, branches.branch_name,
           SUM(accounts.balance) AS total_balance,
           RANK() OVER (ORDER BY SUM(accounts.balance) DESC) AS balance_rank
    FROM branches
    JOIN accounts ON branches.branch_id = accounts.branch_id
    GROUP BY branches.branch_id, branches.branch_name
) ranked_branches
WHERE balance_rank = 1;
-- Expected result:
-- 14 | North Beach | 60000.00


/*
(b) Rank all customers by total balance across all account types. Equal totals
must receive the same rank without gaps. Display customer_id, full_name,
total_balance, and balance_rank. Do not use a CTE. (5 marks)
*/

-- Your answer here
SELECT customers.customer_id,
       customers.first_name || ' ' || customers.last_name AS full_name,
       SUM(accounts.balance) AS total_balance,
       DENSE_RANK() OVER (ORDER BY SUM(accounts.balance) DESC) AS balance_rank
FROM customers
JOIN accounts ON customers.customer_id = accounts.customer_id
GROUP BY customers.customer_id, customers.first_name, customers.last_name
ORDER BY balance_rank;
-- Expected result:
-- 5 | Michael Lee   | 60000.00 | 1
-- 4 | Alice Johnson | 25000.00 | 2
-- 3 | Bob Smith     | 20500.00 | 3
-- 6 | Jennifer Wang | 15000.00 | 4
-- 2 | Jane Doe      | 11500.00 | 5
-- 1 | John Doe      |  5500.00 | 6


/*
(c) Use a CTE to calculate the total number of transactions for every branch,
including branches with no transactions. Return the branch or branches with
the highest total. Display branch_id, branch_name, and total_transactions.
(5 marks)
*/

-- Your answer here
WITH branch_transactions AS (
    SELECT branches.branch_id, branches.branch_name,
           COUNT(transactions.transaction_id) AS total_transactions
    FROM branches
    LEFT JOIN accounts ON branches.branch_id = accounts.branch_id
    LEFT JOIN transactions ON accounts.account_id = transactions.account_id
    GROUP BY branches.branch_id, branches.branch_name
)
SELECT branch_id, branch_name, total_transactions
FROM branch_transactions
WHERE total_transactions = (SELECT MAX(total_transactions) FROM branch_transactions);
-- Expected result:
-- 1 | Main      | 4
-- 8 | South Bay | 4


-- END OF EXAM
