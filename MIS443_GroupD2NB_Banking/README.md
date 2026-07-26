# MIS443_GroupD2NB_Banking

## Course & Assignment
**Course:** MIS 443 - Business Data Management
**Assignment:** Assignment 2 - PostgreSQL Database Development and SQL Practice
**Lecturer:** Mr. Dang Thai Doan
**Quarter:** Quarter 4, Academic Year 2025-2026

## Selected Schema
**Banking** - a relational database simulating a commercial banking management system, consisting of five related tables: `branches`, `customers`, `accounts`, `loans`, and `transactions`.

## Group Information
**Group Name:** D2NB

| No. | Student's Name | Student's IRN |
|---|---|---|
| 1 | Vũ Đông Dương | 2032300044 |
| 2 | Thân Quế Ngọc | 2232300060 |
| 3 | Văn Vũ Quỳnh Như | 2232300079 |
| 4 | Đỗ Hoàng Bảo | 2232300071 |

## Project Description
This project recreates the Banking schema from SQL Practice Online in PostgreSQL using pgAdmin 4. The group designed and implemented five relational tables with appropriate primary keys, foreign keys, and constraints, populated them with CSV data, and completed all 30 SQL practice questions covering filtering, sorting, joins, aggregation, subqueries, window functions, and Common Table Expressions (CTEs).

## Tools Used
- **PostgreSQL** - database management system
- **pgAdmin 4** - database creation and query execution
- **SQL Practice Online** - source schema and question set
- **Microsoft Word** - group report
- **CSV files** - data storage for each table
- **GitHub** - project publishing and version control

## Folder Structure
```
MIS443_GroupD2NB_Banking/
│
├── codes/
│   ├── 01_create_database.sql
│   ├── 02_create_tables_relationships.sql
│   ├── 03_insert_data.sql
│   └── 04_questions_01_30.sql
│
├── data/
│   ├── branches.csv
│   ├── customers.csv
│   ├── accounts.csv
│   ├── transactions.csv
│   └── loans.csv
│
├── report/
│   └── MIS443_GroupD2NB_Banking_Report.docx
│
└── README.md
```

## Instructions for Running the SQL Scripts
Run the scripts in pgAdmin 4 (Query Tool) in the following order:

1. **`01_create_database.sql`** - creates the `Banking` database.
2. **`02_create_tables_relationships.sql`** - creates all five tables with primary keys, foreign keys, and constraints.
3. **`03_insert_data.sql`** - imports data from the CSV files in the `data/` folder into each table.
4. **`04_questions_01_30.sql`** - contains all 30 SQL practice questions with solutions, numbered and commented.

> Ensure the CSV files in `data/` remain in the same relative folder when running the import script, as file paths are referenced from `data/`.

## Source
[SQL Practice Online – Banking Schema](https://www.sql-practice.online/practice/banking?engine=postgresql)

## Acknowledgement
This project was completed collaboratively as a group assignment for MIS 443. All members contributed to database design, SQL query development, testing, and documentation. Individual contributions are detailed in the Word report (Section 8: Responsibilities and contributions of each member).
