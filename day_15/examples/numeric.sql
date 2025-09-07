-- Numeric/Math function examples on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- ABS: absolute difference between payment amount and overall average
WITH avg_amt AS (
  SELECT AVG(amount) AS avg_amount
  FROM payment
)
SELECT p.payment_id,
       p.amount,
       ABS(p.amount - a.avg_amount) AS abs_diff_from_avg
FROM payment p, avg_amt a
ORDER BY abs_diff_from_avg DESC, p.payment_id
LIMIT 10;

-- ROUND: average payment per customer rounded to 2 decimals
SELECT customer_id,
       ROUND(AVG(amount), 2) AS avg_payment_2dp
FROM payment
GROUP BY customer_id
ORDER BY customer_id
LIMIT 10;

-- MOD: remainder of rental_id by 10
SELECT rental_id,
       MOD(rental_id, 10) AS mod_10
FROM rental
ORDER BY rental_id
LIMIT 10;

-- MOD usage: bucket payments by day parity
SELECT MOD(EXTRACT(DAY FROM payment_date)::int, 2) AS day_parity,
       COUNT(*) AS payments
FROM payment
GROUP BY 1
ORDER BY 1;

-- SQRT: square root of film length (minutes)
SELECT film_id,
       length,
       SQRT(length) AS sqrt_length
FROM film
WHERE length IS NOT NULL
ORDER BY film_id
LIMIT 10;

-- FLOOR and CEIL: show lower/upper integer bounds of rental_rate
SELECT film_id,
       rental_rate,
       FLOOR(rental_rate) AS floor_rate,
       CEIL(rental_rate) AS ceil_rate
FROM film
ORDER BY film_id
LIMIT 10;


