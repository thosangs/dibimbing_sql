-- Day 14 - Join Examples (dvdrental)

-- 1) INNER JOIN: customers with their payments
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  p.payment_id,
  p.amount,
  p.payment_date
FROM customer c
INNER JOIN payment p
  ON c.customer_id = p.customer_id
ORDER BY c.customer_id, p.payment_date;

-- 2) LEFT JOIN: all categories with optional films
SELECT
  c.category_id,
  c.name AS category_name,
  f.film_id,
  f.title
FROM category c
LEFT JOIN film_category fc ON fc.category_id = c.category_id
LEFT JOIN film f ON f.film_id = fc.film_id
ORDER BY c.category_id, f.film_id NULLS LAST;

-- 3) RIGHT JOIN: all films with optional category
SELECT
  f.film_id,
  f.title,
  c.category_id,
  c.name AS category_name
FROM category c
RIGHT JOIN film_category fc ON fc.category_id = c.category_id
RIGHT JOIN film f ON f.film_id = fc.film_id
ORDER BY f.film_id, c.category_id NULLS LAST;

-- 4) FULL OUTER JOIN: all categories and all films (match if linked)
SELECT
  c.category_id,
  c.name AS category_name,
  f.film_id,
  f.title
FROM category c
FULL OUTER JOIN film_category fc ON fc.category_id = c.category_id
FULL OUTER JOIN film f ON f.film_id = fc.film_id
ORDER BY COALESCE(c.category_id, -1), COALESCE(f.film_id, -1);

-- 5) CROSS JOIN: Cartesian combination (first 3 categories x first 3 films)
SELECT
  c.category_id,
  c.name AS category_name,
  f.film_id,
  f.title
FROM (SELECT * FROM category ORDER BY category_id LIMIT 3) c
CROSS JOIN (SELECT * FROM film ORDER BY film_id LIMIT 3) f
ORDER BY c.category_id, f.film_id;

-- 6) Multi-join example: payments with customer and film categories (pattern)
-- Note: dvdrental does not link payments to films directly; this is illustrative.
-- SELECT
--   p.payment_id,
--   cu.first_name,
--   cu.last_name,
--   f.title,
--   ca.name AS category_name,
--   p.amount
-- FROM payment p
-- JOIN customer cu ON cu.customer_id = p.customer_id
-- JOIN rental r ON r.customer_id = cu.customer_id
-- JOIN inventory i ON i.inventory_id = r.inventory_id
-- JOIN film f ON f.film_id = i.film_id
-- JOIN film_category fc ON fc.film_id = f.film_id
-- JOIN category ca ON ca.category_id = fc.category_id;


