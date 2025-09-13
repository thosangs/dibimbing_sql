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

-- Filter: payments on a specific calendar date (index-friendly half-open range)
SELECT payment_id, payment_date, amount
FROM payment
WHERE payment_date >= DATE '2005-05-25'
  AND payment_date <  DATE '2005-05-26'
ORDER BY payment_date
LIMIT 10;

-- Alternative: cast timestamp to date (simpler, less index-friendly)
SELECT payment_id, payment_date, amount
FROM payment
WHERE payment_date::date = DATE '2005-05-25'
ORDER BY payment_date
LIMIT 10;

-- Between two dates (inclusive start, exclusive end)
SELECT COUNT(*) AS payments_in_may_2005
FROM payment
WHERE payment_date >= DATE '2005-05-01'
  AND payment_date <  DATE '2005-06-01';

-- Relative window: payments in the last 7 days
SELECT COUNT(*) AS payments_last_7_days
FROM payment
WHERE payment_date >= NOW() - INTERVAL '7 days';

-- BETWEEN: inclusive range (expr >= low AND expr <= high)
-- Numeric example: film length between 90 and 120 minutes (inclusive)
SELECT film_id, title, length
FROM film
WHERE length BETWEEN 90 AND 120
ORDER BY film_id
LIMIT 10;

-- BETWEEN on timestamps: endpoints are inclusive
-- Note: This includes 2005-05-01 00:00:00 up to and including 2005-05-31 00:00:00
SELECT COUNT(*) AS payments_may_2005_between
FROM payment
WHERE payment_date BETWEEN TIMESTAMP '2007-04-01' AND TIMESTAMP '2007-05-31';

-- Recommended for full months/days on timestamp columns: half-open range
SELECT COUNT(*) AS payments_may_2005_half_open
FROM payment
WHERE payment_date >= DATE '2007-04-01'
  AND payment_date <  DATE '2007-06-01';

-- Single calendar day using BETWEEN on date-cast
SELECT payment_id, payment_date, amount
FROM payment
WHERE payment_date::date BETWEEN DATE '2007-04-25' AND DATE '2007-05-25'
ORDER BY payment_date
LIMIT 10;

SELECT DISTINCT payment_date::date
FROM payment
ORDER BY 1