-- Date/Time functions on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- NOW and CURRENT_TIMESTAMP
SELECT NOW() AS now_ts, CURRENT_TIMESTAMP AS current_ts;

-- ADD/SUB INTERVAL: 7 days from now, and 3 hours ago
SELECT NOW() + INTERVAL '7 days' AS in_7_days,
       NOW() - INTERVAL '3 hours' AS three_hours_ago;

-- DATE_TRUNC: payments by month
SELECT DATE_TRUNC('month', payment_date) AS month,
       SUM(amount) AS total_amount
FROM payment
GROUP BY 1
ORDER BY 1;

-- EXTRACT: hour of day from payment_date
SELECT EXTRACT(HOUR FROM payment_date) AS hour_of_day,
       COUNT(*) AS payments
FROM payment
GROUP BY 1
ORDER BY 1;

