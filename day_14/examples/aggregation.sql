-- Day 14 - Aggregation and Grouping Examples (dvdrental)

-- 1) Basic aggregation and aliasing on payments
SELECT
  COUNT(*) AS total_transactions,
  AVG(amount) AS average_payment,
  SUM(amount) AS total_revenue,
  MAX(amount) AS max_payment,
  MIN(amount) AS min_payment
FROM payment;

-- 2) Grouping by customer
SELECT
  p.customer_id,
  COUNT(*) AS num_payments,
  SUM(p.amount) AS total_spent,
  AVG(p.amount) AS avg_payment
FROM payment p
GROUP BY p.customer_id
ORDER BY total_spent DESC, p.customer_id
LIMIT 20;

-- 3) HAVING to filter groups (customers with >= 30 payments)
SELECT
  p.customer_id,
  COUNT(*) AS num_payments,
  SUM(p.amount) AS total_spent
FROM payment p
GROUP BY p.customer_id
HAVING COUNT(*) >= 30
ORDER BY total_spent DESC;

-- 4) Aggregation by month
SELECT
  date_trunc('month', p.payment_date) AS month,
  COUNT(*) AS num_transactions,
  SUM(p.amount) AS revenue
FROM payment p
GROUP BY date_trunc('month', p.payment_date)
ORDER BY month;


