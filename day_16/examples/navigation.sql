-- Navigation functions on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- For each customer, show previous and next rental dates
WITH r AS (
  SELECT customer_id, rental_id, rental_date,
         LAG(rental_date)  OVER (PARTITION BY customer_id ORDER BY rental_date) AS prev_rental_date,
         LEAD(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS next_rental_date,
         FIRST_VALUE(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS first_rental_date,
         LAST_VALUE(rental_date)  OVER (
           PARTITION BY customer_id ORDER BY rental_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
         ) AS last_rental_date,
         NTH_VALUE(rental_date, 2) OVER (
           PARTITION BY customer_id ORDER BY rental_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
         ) AS second_rental_date
  FROM rental
)
SELECT customer_id, rental_id, rental_date,
       prev_rental_date, next_rental_date,
       first_rental_date, last_rental_date, second_rental_date
FROM r
ORDER BY customer_id, rental_date
LIMIT 100;

