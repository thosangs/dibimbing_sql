-- Aggregates as window functions on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- Rolling average and counts of payments per customer over time
WITH p AS (
  SELECT customer_id, payment_id, payment_date, amount
  FROM payment
)
SELECT customer_id,
       payment_id,
       payment_date,
       amount,
       -- Running average over last 3 payments (ROWS frame)
       AVG(amount)  OVER (PARTITION BY customer_id ORDER BY payment_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_last_3,
       -- Cumulative count since first payment
       COUNT(*)     OVER (PARTITION BY customer_id ORDER BY payment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_count,
       -- Running total (cumulative SUM)
       SUM(amount)  OVER (PARTITION BY customer_id ORDER BY payment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
       -- Partition total (same value on each row per customer)
       SUM(amount)  OVER (PARTITION BY customer_id) AS total_per_customer,
       -- Partition max/min
       MAX(amount)  OVER (PARTITION BY customer_id) AS max_amount_for_customer,
       MIN(amount)  OVER (PARTITION BY customer_id) AS min_amount_for_customer
FROM p
ORDER BY customer_id, payment_date
LIMIT 100;

