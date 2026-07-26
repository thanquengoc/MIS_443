/* =====================================================================
   MIS443 - Assignment 2: PostgreSQL Database Development and SQL Practice
   Group: D2NB | Schema: Banking (SQL Practice Online)
   File 02: Create Tables and Relationships
   =====================================================================
   HOW TO RUN THIS FILE
     Run this on the "banking" database (created by file 01).
	 A foreign key can only point at a table that already exists, so a parent
     table must be created before its children:
     Order: branches -> customers -> accounts -> transactions / loans
   ===================================================================== */


-- 1. BRANCHES
CREATE TABLE branches (
    branch_id    INTEGER PRIMARY KEY,
    branch_name  VARCHAR(100),
    city         VARCHAR(50),
    state        VARCHAR(2)
);


-- 2. CUSTOMERS
CREATE TABLE customers (
    customer_id          INTEGER PRIMARY KEY,
    first_name           VARCHAR(50),
    last_name            VARCHAR(50),
    email                VARCHAR(100),
    branch_id            INTEGER REFERENCES branches(branch_id),
    account_opened_date  DATE
);


-- 3. ACCOUNTS
CREATE TABLE accounts (
    account_id    INTEGER PRIMARY KEY,
    customer_id   INTEGER REFERENCES customers(customer_id),
    account_type  VARCHAR(20),
    balance       REAL,
    opened_date   DATE
);


-- 4. TRANSACTIONS
CREATE TABLE transactions (
    transaction_id    INTEGER PRIMARY KEY,
    account_id        INTEGER REFERENCES accounts(account_id),
    transaction_type  VARCHAR(20),
    amount            REAL,
    transaction_date  DATE
);


-- 5. LOANS
CREATE TABLE loans (
    loan_id        INTEGER PRIMARY KEY,
    customer_id    INTEGER REFERENCES customers(customer_id),
    loan_amount    REAL,
    interest_rate  REAL,
    status         VARCHAR(20),
    start_date     DATE
);