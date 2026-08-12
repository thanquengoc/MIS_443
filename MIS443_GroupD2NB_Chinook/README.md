# MIS443_GroupD2NB_Chinook

**A PostgreSQL + Python implementation and business analysis of the Chinook digital media store database, built for MIS 443 - Business Data Management.**

<img src="https://img.shields.io/badge/PostgreSQL-17-0B1E33?style=for-the-badge&logo=postgresql&logoColor=C9A05C" /><img src="https://img.shields.io/badge/Python-Pandas-0B1E33?style=for-the-badge&logo=python&logoColor=C9A05C" /><img src="https://img.shields.io/badge/pgAdmin-4-0B1E33?style=for-the-badge&logo=pgadmin&logoColor=C9A05C" /><img src="https://img.shields.io/badge/Status-Completed-0B1E33?style=for-the-badge&logoColor=C9A05C" />

## Course & Project
- **Course:** MIS 443 - Business Data Management
- **Project:** Course Project - Practical Database Implementation for Data Analysis (Option 2: Implement an Existing Project)
- **Lecturer:** Mr. Dang Thai Doan
- **Timeline:** Week 7
- **Quarter:** Quarter 4, Academic Year 2025-2026

## Group Information
**Group Name:** D2NB

| No. | Student's Name | Student's IRN | GitHub Repository |
|---|---|---|---|
| 1 | Vũ Đông Dương | 2032300044 | [View on GitHub](<https://github.com/DuongvuBBS20/MIS443-Q4-2025_2026/tree/main/MIS443_GroupD2NB_Chinook>) |
| 2 | Thân Quế Ngọc | 2232300060 | [View on GitHub](<https://github.com/thanquengoc/MIS_443/tree/main/MIS443_GroupD2NB_Chinook>) |
| 3 | Văn Vũ Quỳnh Như | 2232300079 | [View on GitHub](<https://github.com/vvqnhu204/MIS443-Q4-2025_2026/tree/main/MIS443_GroupD2NB_Chinook>) |
| 4 | Đỗ Hoàng Bảo | 2232300071 | [View on GitHub](<https://github.com/dohoangbao2004-maker/MIS-443/tree/main/MIS443_GroupD2NB_Chinook>) |

## Selected Schema
**Chinook** - a relational database simulating a digital media store, consisting of eleven related tables: `artist`, `album`, `track`, `genre`, `media_type`, `playlist`, `playlist_track`, `employee`, `customer`, `invoice`, and `invoice_line`.

## Entity-Relationship Diagram
![ERD](report/ERD.png)

## Project Description
This project studies and re-implements the Chinook database schema in PostgreSQL, then uses SQL and Python to answer real business questions about the store's performance - revenue trends, customer value by country, genre profitability, catalog utilization, sales agent performance, and revenue growth over time. The original data (loaded into schema `public`) is re-implemented into a redesigned schema (`new_chinook`) with explicit constraints, then cross-checked row-by-row against the source to confirm a faithful reproduction.

## At a Glance
| Metric | Value |
|---|---|
| Total Tables | 11 |
| Business Questions Analyzed | 6 |
| Database Engine | PostgreSQL |
| Analysis Tools | SQL, Python (pandas, matplotlib) |
| SQL Concepts Applied | Window Functions, CTEs, Aggregations, Anti-Joins |

## Analytical Questions
1. Is the store growing, flat, or shrinking over time?
2. Which countries generate the most revenue, and why?
3. Which genres earn the most, and does catalog size match demand?
4. How much of the catalog has never sold a single unit?
5. Do sales agents differ in ability, or only in customer count?
6. How did revenue accumulate over time, and how long to reach the first $1,000?

## Tools Used
- **PostgreSQL** - database management system
- **pgAdmin 4** - database creation and query execution
- **Python** (pandas, SQLAlchemy/psycopg2, matplotlib) - data extraction and analysis
- **Chinook Database** - source schema and sample dataset
- **Microsoft Word / Canva** - report and presentation
- **GitHub** - project publishing and version control

## Folder Structure
```
MIS443_GroupD2NB_Chinook/
│
├── codes/
│   ├── 00_create_database.sql
│   ├── 01_load_source_data.sql
│   ├── 02_create_new_schema.sql
│   ├── 03_load_new_chinook.sql
│   └── 04_analysis_queries_exercise.sql
│
├── python/
│   └── chinook_analysis.ipynb
│
├── report/
│   ├── MIS443_GroupD2NB_Chinook_Report.docx
│   └── ERD.png
│
├── slide/
│   └── MIS443_GroupD2NB_Chinook_Presentation.pdf
│
└── README.md
```

## Instructions for Running the SQL Scripts (How to Run)

**Step 1 - Create the database**  

Open pgAdmin 4, connect to your PostgreSQL server, and run `codes/00_create_database.sql` from the default `postgres` connection. This creates the `mis443_chinook` database.

**Step 2 - Load the source data**  

Reconnect to `mis443_chinook`, then run `codes/01_load_source_data.sql`. This creates the original Chinook schema (`public`) and populates it with the full sample dataset.

**Step 3 - Build the redesigned schema**  

Run `codes/02_create_new_schema.sql` to create the `new_chinook` schema with all 11 tables, explicit constraints, and indexes.

**Step 4 - Migrate the data**  

Run `codes/03_load_new_chinook.sql` to copy all data from `public` into `new_chinook`. The script ends with a cross-check query - confirm every row count matches between the two schemas before continuing.

**Step 5 - Run the SQL analysis**  

Run `codes/04_analysis_queries_exercise.sql` against the `new_chinook` schema to answer all 6 business questions.

**Step 6 - Run the Python analysis**  

Open `python/chinook_analysis.ipynb` in Jupyter Notebook. Update the database connection string with your own PostgreSQL credentials, then run all cells to reproduce the analysis, charts, and business conclusions for each question.

> Scripts must be run strictly in this order (00 → 01 → 02 → 03 → 04 → python), since each step depends on objects created in the previous one.

## Source
[Chinook Database (lerocha/chinook-database)](https://github.com/lerocha/chinook-database)

## Acknowledgement
This project was completed collaboratively as a group assignment for MIS 443. All members contributed to database design, SQL query development, Python analysis, testing, and documentation. Individual contributions are detailed in the Word report (Section 10: Responsibilities and contributions of each member).