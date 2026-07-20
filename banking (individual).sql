-- =======================
-- 1. Create "branches" table
-- =======================
create table branches (
	branch_id integer primary key,
	branch_name varchar(100) not null,
	city varchar(50),
	state varchar(2)
);

-- =======================
-- 2. Create "customers" table
-- =======================
create table customers (
	customer_id integer primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	email varchar(100),
	branch_id integer,
	account_opened_date date,

	-- foreign key referencing the branches table
	constraint fk_customers_branches
		foreign key (branch_id)
		references branches (branch_id)
);

-- =======================
-- 3. Create "accounts" table
-- =======================
create table accounts(
	account_id integer primary key,
	customer_id integer,
	account_type varchar(20),
	balance real,
	opened_date date,

	-- foreign key referencing the customers table
	constraint fk_accounts_customers
		foreign key (customer_id)
		references customers (customer_id)
);

-- =======================
-- 4. Create "loans" table
-- =======================
create table loans (
	loan_id integer primary key,
	customer_id integer,
	loan_amount real,
	interest_rate real,
	status varchar(20),
	start_date date,

	-- foreign key referencing the customers table
	constraint fk_loans_customers
		foreign key (customer_id)
		references customers (customer_id)
);

-- =======================
-- 5. Create "transactions" table
-- =======================
create table transactions (
	transaction_id integer primary key,
	account_id integer,
	transaction_type varchar(20),
	amount real,
	transaction_date date,

	-- foreign key referencing the accounts table
	constraint fk_transactions_accounts
		foreign key (account_id)
		references accounts (account_id)
);

-- Q1. Return the complete customer roster from the customers table.
select * from customers;

-- Q2. Return all branch names and their cities.
select branch_name, city from branches;

-- Q3. Return all accounts with account type Savings.
select account_id, customer_id, balance from accounts
where account_type = 'Savings';

-- Q4. Return accounts with a balance greater than $10,000.
select customer_id, account_type, balance from accounts
where balance > 10000
order by balance;

-- Q5. Return all transactions of type Deposit.
select transaction_id, account_id, amount, transaction_date from transactions
where transaction_type = 'Deposit'
order by transaction_date;

-- Q6. Return all loans with an Active status.
select loan_id, customer_id, loan_amount, interest_rate from loans
where status = 'Active';

-- Q7. Count the total number of accounts.
select count(*) as total_accounts from ACCOUNTS;

-- Q8. Sum the total amount across all Deposit transactions.
select sum(amount) as total_deposits from transactions
where transaction_type = 'Deposit';

-- Q9. The product team needs a list of all account types offered. Find all unique account types available. Show account_type ordered alphabetically.
select distinct account_type from accounts
order by account_type;

-- Q10. The audit team needs to review mid-month activity. Find all transactions where transaction_date is between January 10 and January 20, 2025 (inclusive). Show transaction_id, account_id, amount, and transaction_date. Order by transaction_date.
select transaction_id, account_id, amount, transaction_date from transactions 
where transaction_date between '2025-01-10' and '2025-01-20' 
order by transaction_date;

-- Q11. The new-accounts team wants to follow up with registered customers who have not yet opened any account. Find all customers who have no accounts. Show first name and last name.
select first_name, last_name from customers 
left join accounts on customers.customer_id = accounts.customer_id 
where accounts.customer_id is null;

-- Q12. The loans department needs to identify customers who have not taken any loan — potential targets for a new loan campaign. Find all customers who have no loans. Show first name and last name ordered by last name.
select first_name, last_name from customers 
left join loans on customers.customer_id = loans.customer_id 
where loans.customer_id is null 
order by last_name;

-- Q13. The relationship management team wants to know how diversified each customer's portfolio is. Show every customer's full name and the number of accounts they hold (including zero). Order by account_count descending, then last name.
select first_name, last_name, count(account_id) as account_count from customers
left join accounts on customers.customer_id = accounts.customer_id
group by customers.customer_id, first_name, last_name
order by account_count desc, last_name;

-- Q14. Calculate the total balance for each account type.
select account_type, sum(balance) as total_balance from accounts 
group by account_type
order by account_type;

-- Q15. Return each customer's name alongside their branch name.
select first_name, last_name, branch_name from customers 
join branches on customers.branch_id = branches.branch_id
order by last_name;

-- Q16. Return each transaction with the transaction date, amount, type, and the customer's last name.
select transaction_date, amount, transaction_type, last_name from transactions
join accounts on transactions.account_id = accounts.account_id 
join customers on accounts.customer_id = customers.customer_id
order by transaction_date;

-- Q17. Return the number of customers assigned to each branch.
select branch_name, count(customer_id) as customer_count from branches 
left join customers on branches.branch_id = customers.branch_id 
group by branches.branch_id, branch_name
order by branches.branch_id;

-- Q18. Return the number of accounts held by each customer.
select customer_id, count(*) as account_count from accounts
group by customer_id
order by customer_id;

-- Q19. Return each loan with the borrower's first and last name, loan amount, and status.
select first_name, last_name, loan_amount, status from loans 
join customers on loans.customer_id = customers.customer_id
order by loan_amount desc;

-- Q20. Return the total account balance held by customers at each branch.
select branch_name, sum(balance) as total_balance from branches 
join customers on branches.branch_id = customers.branch_id
join accounts on customers.customer_id = accounts.customer_id
group by branch_name
order by total_balance desc;

-- Q21. The branch operations team wants a portfolio view of every customer's holdings. Show each customer's name, their branch name, account type, and balance. Order by branch name, then customer last name.
select first_name, last_name, branch_name, account_type, balance from customers
join branches on customers.branch_id = branches.branch_id
join accounts on customers.customer_id = accounts.customer_id
order by branch_name, last_name;

-- Q22. For each account that has transactions, show total deposits and total withdrawals side by side using conditional aggregation. Order by account_id.
select account_id,
    sum(case when transaction_type = 'Deposit' then amount else 0 end) as total_deposits,
    sum(case when transaction_type = 'Withdrawal' then amount else 0 end) as total_withdrawals
from transactions
group by account_id
order by account_id;

-- Q23. Group transactions by year-month (using strftime). Show month, transaction count, and total amount. Order by month ascending.
---- Using to_char (PostgreSQL) instead of strftime (SQLite-only)
select to_char(transaction_date, 'yyyy-mm') as month,
    count(*) as transaction_count,
    sum(amount) as total_amount
from transactions
group by month
order by month asc;

-- Q24. The operations team wants to contact customers who have never used their accounts. Find customers who have no transactions in any of their accounts. Show first name and last name.
select first_name, last_name from customers
where not exists (
    select * from accounts
    join transactions on accounts.account_id = transactions.account_id
    where accounts.customer_id = customers.customer_id
);

-- Q25. Create a cash flow list combining all deposits (labelled 'Income') and all withdrawals (labelled 'Expense') into one unified report. Show account_id, amount, flow_type, and transaction_date. Order by transaction_date.
select account_id, amount, 'Income' as flow_type, transaction_date from transactions
where transaction_type = 'Deposit'
union all
select account_id, amount, 'Expense' as flow_type, transaction_date from transactions
where transaction_type = 'Withdrawal'
order by transaction_date;

-- Q26. Find the customer with the largest total active loan amount. Show first name, last name, and total_loans. Only include Active loans.
select first_name, last_name, sum(loan_amount) as total_loans from customers 
join loans on customers.customer_id = loans.customer_id
where status = 'Active'
group by customers.customer_id, first_name, last_name
order by total_loans desc
limit 1;

-- Q27. The wealth management team wants to identify accounts performing above their peer group. Find accounts with a balance above the average balance for their account_type. Show account_id, account_type, balance, and customer name.
select account_id, account_type, balance, first_name, last_name from accounts
join customers on accounts.customer_id = customers.customer_id
where balance > (
    select avg(balance) 
    from accounts as sub
    where sub.account_type = accounts.account_type
)
order by account_type, balance desc;

-- Q28. Rank accounts by balance within each account type using a window function. Show account_id, account_type, balance, and balance_rank. Order by account_type, then rank.
select account_id, account_type, balance, 
    rank() over (partition by account_type order by balance desc) as balance_rank
from accounts
order by account_type, balance_rank;

-- Q29. The branch management team wants to identify the top depositor at each location. Find the customer with the highest total account balance in each branch. Show first name, last name, branch name, and total_balance.
with customer_balances as (
    select first_name, last_name, branch_name, 
        sum(balance) as total_balance,
        rank() over (partition by branch_name order by sum(balance) desc) as rank
    from customers
    join branches on customers.branch_id = branches.branch_id
    join accounts on customers.customer_id = accounts.customer_id
    group by customers.customer_id, first_name, last_name, branch_name
)
select first_name, last_name, branch_name, total_balance
from customer_balances
where rank = 1;

-- Q30. The product team wants a breakdown of account distribution by balance tier. Using a CTE, classify accounts into tiers: High (balance >= 10000), Medium (balance >= 3000), Low (below 3000). Show each tier's account count, average balance, and total balance. Order by avg_balance descending.
with account_tiers as (
    select balance, case
       when balance >= 10000 then 'High'
       when balance >= 3000 then 'Medium'
       else 'Low'
     end as tier
    from accounts
)
select tier,
    count(*) as account_count,
    round(cast(avg(balance) as numeric), 2) as avg_balance,
    sum(balance) as total_balance
from account_tiers
group by tier
order by avg_balance desc;