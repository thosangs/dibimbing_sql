-- Progressive window function intro on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- 1) No OVER: classic aggregation (total payments per customer)
SELECT customer_id,
       SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
ORDER BY total_amount DESC
LIMIT 10;

-- 2) OVER (PARTITION BY ...): same total shown on every row per customer
SELECT payment_id,
       customer_id,
       payment_date,
       amount,
       SUM(amount) OVER (PARTITION BY customer_id) AS total_per_customer
FROM payment
ORDER BY customer_id, payment_date
LIMIT 100;

-- 3) OVER (PARTITION BY ... ORDER BY ...): running total per customer over time
SELECT payment_id,
       customer_id,
       payment_date,
       amount,
       SUM(amount) OVER (
         PARTITION BY customer_id
         ORDER BY payment_date
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total
FROM payment
ORDER BY customer_id, payment_date
LIMIT 200;


