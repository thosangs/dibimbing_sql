-- Day 17: Live Coding on dvdrental
-- Story: The New Release Push
-- In this 3-hour session, you’ll help the dvdrental chain evaluate a
-- “New Release Push” campaign. Start with quick diagnostics, then move into
-- business questions (cohorts and churn), and end with advanced windowing.
-- Solve problems in order to follow the narrative.

-- Connection:
-- psql "postgresql://user:password@localhost:5432/dvdrental"


-- =====================
-- EASY ANALYTICS (8)
-- =====================

-- E1) Daily rentals trend (last 14 days):
--     Show total rentals per day for the last 14 days.

-- E2) Top 10 most-rented films overall:
--     List film_id, title, and total rentals.

-- E3) Monthly payments trend:
--     Show total payment amount per month (chronological order).

-- E4) New customers per month:
--     Using each customer’s first rental month (MIN(rental_date)), count new customers by month.

-- E5) Rentals by category:
--     For each category, compute total rentals. Order by rentals desc.

-- E6) Average rental duration by category:
--     Compute average hours between rental.rental_date and rental.return_date for each category.

-- E7) Top 10 cities by rentals:
--     Count rentals by customer city; show top 10.

-- E8) Active customers in the last 30 days:
--     Count distinct customers who have at least 1 rental in the last 30 days of data.


-- =====================
-- MEDIUM BUSINESS (6)
-- Includes cohort and churn analysis
-- =====================

-- M1) Customer cohort retention (months 0..3):
--     Define cohort as the month of a customer’s first rental. For each cohort_month,
--     compute how many customers rented in months 0, 1, 2, and 3 after their first rental month.
--     Output columns: cohort_month, m0_active, m1_active, m2_active, m3_active.

-- M2) Monthly churn rate (last 6 months):
--     Define a customer as “active in month X” if they rented in that month.
--     Define “churned in month X” as customers active in month X-1 but not in month X.
--     For the last 6 months of data, compute churn_rate = churned / active_prev_month.

-- M3) Reactivations:
--     For each month, count customers who had no rentals in the previous 2 months,
--     but rented in the current month (reactivated customers).

-- M4) Campaign impact (pre vs post):
--     Assume campaign launch date = 2005-07-01. Compare average monthly rentals per active customer
--     in the 2 months before vs the 2 months after launch. Show before_avg, after_avg, delta.

-- M5) Inventory restock alert:
--     For each film, compute total copies (inventory rows) and currently rented copies
--     (rental rows with return_date IS NULL). Flag films with available_copies < 2.

-- M6) Cross-sell opportunity (also-rented):
--     For the film titled 'ACADEMY DINOSAUR', find the top 5 other films most frequently co-rented
--     by the same customers across their rentals. Return other_film_title and co_rental_count.


-- =====================
-- HARD (4) — WINDOWING WITH CUSTOM FRAMES
-- =====================

-- H1) 7-day rolling rentals by category:
--     1) Build daily rentals per category.
--     2) Compute a 7-day rolling sum using window frame: ROWS BETWEEN 6 PRECEDING AND CURRENT ROW.
--     Output: rental_day, category, rentals_7d.

-- H2) 30-day rolling customer spend:
--     For each customer and each payment row (ordered by payment_date), compute the rolling 30-day total spend
--     using a RANGE frame: RANGE BETWEEN INTERVAL '30 days' PRECEDING AND CURRENT ROW.
--     Output: customer_id, payment_date, amount, spend_30d.

-- H3) Customer 3-payment moving average:
--     For each customer, order payments by payment_date and compute a 3-payment moving average of amount
--     using ROWS BETWEEN 2 PRECEDING AND CURRENT ROW.
--     Output: customer_id, payment_id, payment_date, amount, movavg_3.

-- H4) Monthly film contribution curve:
--     For each month, rank films by rentals (desc), then compute the cumulative share of rentals
--     using a window frame (e.g., ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW).
--     Output: month, film_id, title, rentals, cum_rentals, cum_share.
