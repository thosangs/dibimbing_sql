-- Day 14 - Filtering and Advanced Filtering Examples (dvdrental)

-- 1) Films with high rental_rate AND short length
SELECT
  f.film_id,
  f.title,
  f.rental_rate,
  f.length
FROM film f
WHERE f.rental_rate > 3.99
  AND f.length < 50
ORDER BY f.rental_rate DESC, f.film_id
LIMIT 20;

-- 2) Customers in 'Indonesia' OR a specific customer_id
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  co.country
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN city ci ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id
WHERE co.country = 'Indonesia'
   OR c.customer_id = 358
ORDER BY c.customer_id;

-- 3) Payments between two dates
SELECT
  p.payment_id,
  p.customer_id,
  p.amount,
  p.payment_date
FROM payment p
WHERE p.payment_date BETWEEN '2005-05-01' AND '2005-06-01'
ORDER BY p.payment_date;

-- 4) Films in selected categories (IN)
SELECT
  f.film_id,
  f.title,
  c.name AS category
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.name IN ('Action', 'Comedy', 'Family')
ORDER BY f.film_id;

-- 5) LIKE: customers whose first_name starts with 'D'
SELECT
  c.first_name,
  c.last_name
FROM customer c
WHERE c.first_name LIKE 'D%';


