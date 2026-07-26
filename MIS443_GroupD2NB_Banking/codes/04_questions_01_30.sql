/* =====================================================================
   MIS443 - Assignment 2: PostgreSQL Database Development and SQL Practice
   Group: D2NB | Schema: Banking (SQL Practice Online)
   File 04: SQL Practice Questions (Q1-Q30)
   =====================================================================
   Run this on the "banking" database after files 01-03.

   Note: The formatting may vary slightly because each question was written by the team member responsible for it.
   ===================================================================== */


/* Q1: The customer relations team is conducting a full audit of the client master list.
   Return the complete customer roster from the customers table. */
select * from customers;


-- Q2: Return all branch names and their cities.
SELECT branch_name, city
FROM branches;


-- Q3: Return all accounts with account type Savings.
SELECT accounts.account_id, accounts.customer_id, accounts.balance
FROM accounts
WHERE account_type = 'Savings';


-- Q4. Return accounts with a balance greater than $10,000.
select customer_id, account_type, balance from accounts
where balance > 10000
order by balance;


/* Q5: The operations team is reconciling all inbound cash flows and needs a
   full list of deposit transactions.
   Return transaction_id, account_id, amount, and transaction_date,
   for transaction_type = 'Deposit', ordered by transaction_date. */
SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
WHERE transaction_type = 'Deposit'
ORDER BY transaction_date;


-- Q6: Return all loans with an Active status.
SELECT loan_id, customer_id, loan_amount, interest_rate
FROM loans
WHERE
status = 'Active'
;

-- Q7. Count the total number of accounts.
SELECT COUNT(*) AS total_accounts
FROM accounts;


-- Q8. Sum the total amount across all Deposit transactions.
select sum(amount) as total_deposits from transactions
where transaction_type = 'Deposit';


/* Q9: The product team needs a list of all account types offered.
   Show account_type ordered alphabetically. */
SELECT DISTINCT account_type
FROM accounts
ORDER BY account_type;


/* Q10: The audit team needs to review mid-month activity.
   Find all transactions where transaction_date is between January 10 and
   January 20, 2025 (inclusive). Order by transaction_date. */
SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
WHERE
transaction_date >= '2025-01-10' AND transaction_date <= '2025-01-20'
ORDER BY transaction_date ASC;


-- Q11. Find all customers who have no accounts. Show first name and last name.
SELECT c.first_name, c.last_name
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL
ORDER BY c.last_name;


-- Q12. Find all customers who have no loans. Show first name and last name ordered by last name.
select first_name, last_name from customers 
left join loans on customers.customer_id = loans.customer_id 
where loans.customer_id is null 
order by last_name;


/* Q13: The relationship management team wants to know how diversified each
   customer's portfolio is. Order by account_count descending, then last name. */
SELECT c.first_name, c.last_name, COUNT(a.account_id) AS account_count
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY account_count DESC, c. last_name;


-- Q14: Calculate the total balance for each account type.
SELECT account_type, SUM(balance) AS total_balance
FROM accounts
GROUP BY account_type
ORDER BY account_type ;


-- Q15. Return each customer's name alongside their branch name.
SELECT c.first_name, c.last_name, b.branch_name
FROM customers c JOIN branches b
ON b.branch_id = c.branch_id
ORDER BY last_name;


-- Q16. Return each transaction with the transaction date, amount, type, and the customer's last name.
select transaction_date, amount, transaction_type, last_name from transactions
join accounts on transactions.account_id = accounts.account_id 
join customers on accounts.customer_id = customers.customer_id
order by transaction_date;


/* Q17: The branch performance team needs a headcount of active customers per
   branch to measure branch utilisation.
   Use LEFT JOIN so branches with zero customers still appear. Order by branch_id. */
SELECT b.branch_name, COUNT(c.customer_id) AS customer_count
FROM branches b
LEFT JOIN customers c ON b.branch_id = c.branch_id
GROUP BY b.branch_id, b.branch_name
ORDER BY b.branch_id;


-- Q18: Return the number of accounts held by each customer.
SELECT customer_id, COUNT(account_id) AS account_count
FROM accounts
GROUP BY customer_id
ORDER BY customer_id;


-- Q19. Return each loan with the borrower's first and last name, loan amount, and status.
SELECT c.first_name, c.last_name, l.loan_amount, l.status FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
ORDER BY l.loan_amount DESC, c.last_name;


-- Q20. Return the total account balance held by customers at each branch.
select branch_name, sum(balance) as total_balance from branches 
join customers on branches.branch_id = customers.branch_id
join accounts on customers.customer_id = accounts.customer_id
group by branch_name
order by total_balance desc;


/* Q21: The branch operations team wants a portfolio view of every customer's
   holdings. Order by branch name, then customer last name. */
SELECT c.first_name, c. last_name, b.branch_name, a.account_type, a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN branches b ON c.branch_id = b.branch_id
ORDER BY b.branch_name, c. last_name;


/* Q22: For each account that has transactions, show total deposits and total
   withdrawals side by side using conditional aggregation. Order by account_id. */
SELECT account_id,
SUM(CASE WHEN transaction_type = 'Deposit' THEN amount ELSE 0 END) AS total_deposits,
SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) AS total_withdrawals
FROM transactions
GROUP BY account_id
ORDER BY account_id;


/* Q23: Group transactions by year-month. Show month, transaction count, and
   total amount. Order by month ascending.
   Note: using TO_CHAR instead of STRFTIME, because TO_CHAR is the standard
   PostgreSQL function for formatting dates; STRFTIME is only supported by SQLite. */
SELECT TO_CHAR(transaction_date, 'YYYY-MM') AS month,
       COUNT(transaction_id) AS transaction_count,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY month
ORDER BY month ASC;


-- Q24. Find customers who have no transactions in any of their accounts. Show first name and last name.
select first_name, last_name from customers
where not exists (
    select * from accounts
    join transactions on accounts.account_id = transactions.account_id
    where accounts.customer_id = customers.customer_id
);


/* Q25: Create a cash flow list combining all deposits (labelled 'Income') and
   all withdrawals (labelled 'Expense') into one unified report. Order by transaction_date. */
SELECT account_id, amount, 'Income' AS flow_type, transaction_date
FROM transactions
WHERE transaction_type = 'Deposit'
UNION ALL
SELECT account_id, amount, 'Expense' AS flow_type, transaction_date
FROM transactions
WHERE transaction_type = 'Withdrawal'
ORDER BY transaction_date;


-- Q26: Find the customer with the largest total active loan amount. Only include Active loans.
SELECT c. first_name,c. last_name, SUM(l. loan_amount) AS total_loans
FROM customers c
INNER JOIN loans l
ON c.customer_id = l.customer_id
WHERE l.status='Active'
GROUP BY c. first_name, c.last_name
ORDER BY total_loans DESC
LIMIT 1;


/* Q27: The wealth management team wants to identify accounts performing above
   their peer group. Find accounts with a balance above the average balance
   for their account_type. */
SELECT a.account_id, a.account_type, a.balance, c.first_name, c.last_name FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.balance > (select AVG(a2.balance) FROM accounts a2 WHERE a2.account_type = a.account_type)
ORDER BY a.account_id;


-- Q28. Rank accounts by balance within each account type using a window function.
select account_id, account_type, balance, 
    rank() over (partition by account_type order by balance desc) as balance_rank
from accounts
order by account_type, balance_rank;


/* Q29: The branch management team wants to identify the top depositor at each
   location. Find the customer with the highest total account balance in each branch. */
WITH customer_balances AS (
SELECT c.customer_id, c.first_name, c.last_name, c.branch_id, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a
ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c. first_name, c. last_name, c.branch_id),
ranked AS (
SELECT *,
RANK() OVER (PARTITION BY branch_id
ORDER BY total_balance DESC) AS rnk
FROM customer_balances)
SELECT r.first_name, r. last_name, b.branch_name, r.total_balance
FROM ranked r
JOIN branches b ON r.branch_id = b.branch_id
WHERE r.rnk = 1
ORDER BY b.branch_name;


/* Q30: The product team wants a breakdown of account distribution by balance tier.
   Tiers: High (balance >= 10000), Medium (balance >= 3000), Low (below 3000).
   Order by avg_balance descending. */
WITH account_tiers
AS (SELECT account_id, account_type, balance,
CASE
WHEN balance >= 10000 THEN 'High'
WHEN balance >= 3000 THEN 'Medium'
ELSE 'Low'
END AS tier
FROM accounts)
SELECT tier, COUNT(*) AS account_count, AVG(balance) AS avg_balance, SUM(balance) AS total_balance
FROM account_tiers
GROUP BY tier
ORDER BY avg_balance DESC;