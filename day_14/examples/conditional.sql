-- Day 14 - Conditional Logic Examples (dvdrental)

-- 1) CASE WHEN categorizing film length
SELECT
  f.title,
  f.length,
  CASE
    WHEN f.length <= 50 THEN 'Short'
    WHEN f.length > 50 AND f.length <= 120 THEN 'Medium'
    ELSE 'Long'
  END AS movie_length_category
FROM film f;

-- 2) COALESCE to show address2 or 'N/A'
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  COALESCE(a.address2, 'N/A') AS address2_label
FROM customer c
JOIN address a ON a.address_id = c.address_id
ORDER BY c.customer_id
LIMIT 50;

-- 3) GREATEST/LEAST to clamp payment amounts
SELECT
  p.payment_id,
  p.amount,
  GREATEST(p.amount, 0) AS amount_floor_zero,
  LEAST(p.amount, 10.00) AS amount_cap_10
FROM payment p
ORDER BY p.payment_id
LIMIT 50;

-- 4) CASE with ranges for payment tiers
SELECT
  p.payment_id,
  p.amount,
  CASE
    WHEN p.amount < 2 THEN 'Bronze'
    WHEN p.amount < 5 THEN 'Silver'
    WHEN p.amount < 8 THEN 'Gold'
    ELSE 'Platinum'
  END AS payment_tier
FROM payment p
ORDER BY p.payment_id
LIMIT 50;


