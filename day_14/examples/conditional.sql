-- Day 14 - Conditional Logic Examples
-- Datasets: film (dvdrental) and payments/customers (e-commerce sim)

-- 1) CASE WHEN categorizing film length (dvdrental-style example per logic.md)
SELECT
  title,
  length,
  CASE
    WHEN length <= 50 THEN 'Short'
    WHEN length > 50 AND length <= 120 THEN 'Medium'
    ELSE 'Long'
  END AS movie_length_category
FROM film;

-- 2) COALESCE to handle nulls (customer country)
SELECT
  customer_id,
  first_name,
  last_name,
  COALESCE(country, 'Unknown') AS country_label
FROM customers
ORDER BY customer_id
LIMIT 50;

-- 3) GREATEST/LEAST to clamp values (example on payment amounts)
SELECT
  payment_id,
  amount,
  GREATEST(amount, 0) AS amount_floor_zero,
  LEAST(amount, 1000) AS amount_cap_1000
FROM payments
ORDER BY payment_id
LIMIT 50;

-- 4) CASE with ranges for payment tiers
SELECT
  payment_id,
  amount,
  CASE
    WHEN amount < 20 THEN 'Bronze'
    WHEN amount < 100 THEN 'Silver'
    WHEN amount < 250 THEN 'Gold'
    ELSE 'Platinum'
  END AS payment_tier
FROM payments
ORDER BY payment_id
LIMIT 50;


