/* =====================================================================
   MIS443 - Assignment 2: PostgreSQL Database Development and SQL Practice
   Group: D2NB | Schema: Banking (SQL Practice Online)
   File 03: Importing the Data
   =====================================================================
   Data is loaded from the CSV files in data/.

   In pgAdmin: right-click the table -> Import/Export Data... -> Import,
   Format csv, Header Yes.

   Import in this order, or the foreign keys reject the rows:
   branches -> customers -> accounts -> transactions -> loans

   If you would rather not import the CSV files, run the INSERT
   statements below in the Query Tool (connected to "banking", after
   file 02). Same rule on order: a row can only point at a row that
   already exists, so branches go in first and transactions/loans last.
   Run this block once; a second run fails on the duplicate primary keys.
   ===================================================================== */


-- 1. Branches
INSERT INTO branches (branch_id, branch_name, city, state) VALUES
(1, 'Main Street', 'New York',    'NY'),
(2, 'Downtown',    'Los Angeles', 'CA'),
(3, 'Central',     'Chicago',     'IL'),
(4, 'Riverside',   'Houston',     'TX'),
(5, 'Plaza',       'Phoenix',     'AZ');

-- 2. Customers
INSERT INTO customers (customer_id, first_name, last_name, email, branch_id, account_opened_date) VALUES
(1001, 'Alice',  'Smith',    'alice.smith@email.com', 1, '2020-03-15'),
(1002, 'Bob',    'Johnson',  'bob.j@email.com',       1, '2019-07-22'),
(1003, 'Carol',  'Williams', 'carol.w@email.com',     2, '2021-01-10'),
(1004, 'David',  'Brown',    'david.b@email.com',     2, '2020-11-05'),
(1005, 'Eva',    'Davis',    'eva.d@email.com',       3, '2022-06-18'),
(1006, 'Frank',  'Miller',   'frank.m@email.com',     3, '2018-09-30'),
(1007, 'George', 'Wilson',   'george.w@email.com',    5, '2025-03-01');

-- 3. Accounts
INSERT INTO accounts (account_id, customer_id, account_type, balance, opened_date) VALUES
(5001, 1001, 'Checking', 3500.50, '2020-03-15'),
(5002, 1001, 'Savings',  12000,   '2020-03-16'),
(5003, 1002, 'Checking', 2100.75, '2019-07-22'),
(5004, 1003, 'Savings',  8500,    '2021-01-10'),
(5005, 1004, 'Checking', 4200.25, '2020-11-05'),
(5006, 1004, 'CD',       15000,   '2021-02-01'),
(5007, 1005, 'Checking', 1800,    '2022-06-18'),
(5008, 1006, 'Savings',  25000,   '2018-09-30');

-- 4. Transactions
INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, transaction_date) VALUES
(1, 5001, 'Deposit',    500,  '2025-01-05'),
(2, 5001, 'Withdrawal', 200,  '2025-01-08'),
(3, 5002, 'Deposit',    1000, '2025-01-10'),
(4, 5003, 'Withdrawal', 150,  '2025-01-12'),
(5, 5004, 'Deposit',    250,  '2025-01-15'),
(6, 5005, 'Deposit',    750,  '2025-01-18'),
(7, 5001, 'Deposit',    300,  '2025-01-20'),
(8, 5007, 'Withdrawal', 100,  '2025-01-22');

-- 5. Loans
INSERT INTO loans (loan_id, customer_id, loan_amount, interest_rate, status, start_date) VALUES
(1, 1001, 15000, 5.5,  'Active', '2023-04-01'),
(2, 1002, 25000, 6,    'Active', '2022-08-15'),
(3, 1004, 10000, 4.75, 'Paid',   '2020-06-01'),
(4, 1006, 50000, 5.25, 'Active', '2021-11-20');