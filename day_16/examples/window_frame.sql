-- Window frame clause examples on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- Demonstrate ROWS, RANGE, and GROUPS frames

-- 1) ROWS frame: last 2 rows and current row per customer by payment_date
SELECT customer_id,
       payment_id,
       payment_date,
       amount,
       SUM(amount) OVER (
         PARTITION BY customer_id
         ORDER BY payment_date
         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS sum_rows_last_2
FROM payment
ORDER BY customer_id, payment_date
LIMIT 100;

-- 2) RANGE frame: all payments within the same day as current row per customer
SELECT customer_id,
       payment_id,
       payment_date::date AS day,
       amount,
       SUM(amount) OVER (
         PARTITION BY customer_id
         ORDER BY payment_date
         RANGE BETWEEN CURRENT ROW AND CURRENT ROW
       ) AS sum_same_timestamp_range
FROM payment
ORDER BY customer_id, payment_date
LIMIT 100;

-- 3) GROUPS frame: sum over current and previous value groups by day per customer
SELECT customer_id,
       payment_id,
       payment_date::date AS day,
       amount,
       SUM(amount) OVER (
         PARTITION BY customer_id
         ORDER BY payment_date::date
         GROUPS BETWEEN 1 PRECEDING AND CURRENT ROW
       ) AS sum_groups_prev1_day
FROM payment
ORDER BY customer_id, payment_date
LIMIT 100;


