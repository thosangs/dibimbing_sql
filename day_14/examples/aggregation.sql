-- Day 14 - Aggregation and Grouping Examples
-- Dataset: payments, customers

-- 1) Basic aggregation and aliasing
SELECT
  COUNT(*) AS total_transactions,
  AVG(amount) AS average_payment,
  SUM(amount) AS total_revenue,
  MAX(amount) AS max_payment,
  MIN(amount) AS min_payment
FROM payments;

-- 2) Grouping by customer
SELECT
  customer_id,
  COUNT(*) AS num_payments,
  SUM(amount) AS total_spent,
  AVG(amount) AS avg_payment
FROM payments
GROUP BY customer_id
ORDER BY total_spent DESC, customer_id
LIMIT 20;

-- 3) HAVING to filter groups
SELECT
  customer_id,
  COUNT(*) AS num_payments,
  SUM(amount) AS total_spent
FROM payments
GROUP BY customer_id
HAVING COUNT(*) >= 30
ORDER BY total_spent DESC;

-- 4) Aggregation by time window (example: monthly)
SELECT
  date_trunc('month', payment_date) AS month,
  COUNT(*) AS num_transactions,
  SUM(amount) AS revenue
FROM payments
GROUP BY date_trunc('month', payment_date)
ORDER BY month;


