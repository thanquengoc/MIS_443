-- =============================================================================
-- MIS 443 - 04_analysis_queries_exercise.sql   
-- Database : mis443_chinook
-- Schema   : new_chinook
-- Tables   : artist, album, genre, media_type, playlist, playlist_track,
--            track, employee, customer, invoice, invoice_line
-- =============================================================================

SET search_path TO new_chinook;


-- -----------------------------------------------------------------------------
-- Q1. QUESTION: Is the store growing, flat, or shrinking over time?
SELECT 
	EXTRACT(YEAR FROM invoice_date)::INT AS year,
    COUNT(*) AS invoices,
    COUNT(DISTINCT customer_id) AS active_customers,
    SUM(total) AS revenue
FROM invoice
GROUP BY 1
ORDER BY 1;

-- CONCLUSION:
-- The store's revenue is showing signs of flattening, with no significant
-- year-over-year growth. It needs to redesign its promotional campaigns
-- or expand its song catalog to stimulate purchasing.

-- -----------------------------------------------------------------------------
-- Q2. QUESTION: Which countries generate the most revenue, and is a country
--     valuable because it has many customers or because each one spends more?
SELECT c.country,
       COUNT(DISTINCT c.customer_id) AS num_customers,
       SUM(i.total)                  AS total_revenue,
       CASE WHEN COUNT(DISTINCT c.customer_id) >= 3
            THEN ROUND(SUM(i.total) / COUNT(DISTINCT c.customer_id), 2)
       END                           AS avg_spend_per_customer,
       ROUND(100.0 * SUM(i.total) / (SELECT SUM(total) FROM invoice), 1) AS pct_of_revenue
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;

-- CONCLUSION:
-- The USA leads in both total revenue and average spend per customer.
-- Canada ranks second in revenue but has the lower average spend per
-- customer. The store should keep acquiring customers in the USA and
-- design upsell/bundle offers to raise average spend in Canada.


-- -----------------------------------------------------------------------------
-- Q3. QUESTION: Which genres earn the most, and does catalog size match demand?
SELECT 
	   g.name AS genre,
       COUNT(DISTINCT t.track_id) AS tracks_in_catalog,
       COALESCE(SUM(il.unit_price * il.quantity), 0) AS revenue,
       ROUND(COALESCE(SUM(il.unit_price * il.quantity), 0)
             / COUNT(DISTINCT t.track_id), 2) AS revenue_per_track
FROM genre g
LEFT JOIN track t ON t.genre_id = g.genre_id
LEFT JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY g.genre_id, g.name
ORDER BY revenue DESC;

/*
CONCLUSION:
Rock generates the highest revenue and also has by far the largest
catalog; other top genres (Latin, Metal, Alternative & Punk) follow
the same pattern, where revenue scales with catalog size. TV Shows is
an exception: despite the smallest catalog in the top 5, it still
generated comparable revenue, suggesting stronger per-track demand
than its catalog size alone would predict.
*/

-- -----------------------------------------------------------------------------
-- Q4. QUESTION: How much of the catalog has never sold a single unit?

-- Q4a. How much of the catalog has never sold a single unit?
SELECT
    COUNT(*) AS never_sold_tracks,
    (SELECT COUNT(*) FROM track) AS total_tracks,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM track), 1) AS pct_of_catalog
FROM track t
LEFT JOIN invoice_line il ON il.track_id = t.track_id
WHERE il.track_id IS NULL;

/* there are 3503 totals of tracks and deeping in that there 
are 1519 never-sold-tracks, representing 43.4%, comparing to 
the total of tracks in all genre */

-- Q4b. Where does it sit?
SELECT
    g.name AS genre,
    COUNT(DISTINCT t.track_id) AS total_tracks,
    COUNT(DISTINCT t.track_id) FILTER (WHERE il.track_id IS NULL) AS unsold_tracks,
    ROUND(100.0 * COUNT(DISTINCT t.track_id) FILTER (WHERE il.track_id IS NULL)
          / COUNT(DISTINCT t.track_id), 1) AS pct_unsold
FROM genre g
JOIN track t ON t.genre_id = g.genre_id
LEFT JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY g.genre_id, g.name
ORDER BY unsold_tracks DESC
LIMIT 10;

/*
Rock has the most unsold tracks in absolute
terms (552), followed by Latin (239) and Metal (143), but Rock's
unsold rate is actually lower (42.6%) than TV Shows (53.8%) and Jazz
(47.7%), meaning its high count is simply a function of catalog size,
not a sign it performs worse than other genres. The store could
review low-selling tracks and improve marketing to increase sales.
*/

-- -----------------------------------------------------------------------------
-- Q5. QUESTION: Do sales agents differ in ability, or only in how many
--     customers they were assigned?
SELECT 
	CONCAT(e.first_name,' ',e.last_name) AS agent,
    COUNT(DISTINCT c.customer_id) AS customers_assigned,
    COUNT(i.invoice_id) AS invoices,
	SUM(i.total) AS revenue,
    ROUND(SUM(i.total) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer
FROM employee e
JOIN customer c ON c.support_rep_id = e.employee_id
JOIN invoice  i ON i.customer_id    = c.customer_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY revenue DESC;

/* 
CONCLUSION:
The 15.7% revenue gap comes from how many customers each agent was given, 
21, 20 and 18, not from ability. Per customer all three land near $39, 
and with samples that small the difference sits inside ordinary sampling error. 
No difference was detected, which is not the same as proving they perform alike. 
This is also an online store: customers buy on their own, and the schema 
records only who is assigned to whom (customer.support_rep_id), nothing 
about what the agent did. Judging support work would need response times, 
satisfaction scores, first contact resolution, and refund rates, none of 
which the database holds.
*/

-- -----------------------------------------------------------------------------
-- Q6. QUESTION: How did revenue accumulate over time, and how long did it take
--     to reach the first $1,000?

-- Q6a. Total sales over time (running total by day)
SELECT
    invoice_date::DATE AS revenue_date,
    SUM(SUM(total)) OVER (ORDER BY invoice_date::DATE) AS cumulative_revenue
FROM invoice
GROUP BY invoice_date::DATE
ORDER BY revenue_date;

-- Q6b. The date sales reached $1,000, and the days since the first sale
WITH cumulative AS (
    SELECT
        invoice_date::DATE AS revenue_date,
        SUM(SUM(total)) OVER (ORDER BY invoice_date::DATE) AS cumulative_revenue
    FROM invoice
    GROUP BY invoice_date::DATE
)
SELECT
    revenue_date AS date_reached_1000,
    cumulative_revenue,
    revenue_date - (SELECT MIN(invoice_date)::DATE FROM invoice) AS days_since_first_invoice
FROM cumulative
WHERE cumulative_revenue >= 1000
ORDER BY revenue_date
LIMIT 1;
-- ANSWER:
-- The store took 785 days (~2.2 years) to make its first $1,000 on 2023-02-25.
-- The total revenue is only $2,328.60 over almost 5 years (2021-2025), which shows very slow and steady growth.
-- Reaching $1,000 halfway through this time shows stable sales but no big jump at the beginning.

