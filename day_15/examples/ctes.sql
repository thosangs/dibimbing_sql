-- CTE examples on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- Top 10 spenders
WITH customer_spend AS (
  SELECT customer_id, SUM(amount) AS total_spend
  FROM payment
  GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name, cs.total_spend
FROM customer c
JOIN customer_spend cs USING (customer_id)
ORDER BY cs.total_spend DESC
LIMIT 10;

-- Second most recent rental per customer
WITH ranked_rentals AS (
  SELECT customer_id, rental_id, rental_date,
         ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY rental_date DESC) AS rn
  FROM rental
)
SELECT customer_id, rental_id, rental_date
FROM ranked_rentals
WHERE rn = 2
ORDER BY customer_id;

