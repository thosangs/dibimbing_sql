-- Subquery examples on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- Customers who rented 'ACADEMY DINOSAUR'
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE c.customer_id IN (
  SELECT r.customer_id
  FROM rental r
  JOIN inventory i ON i.inventory_id = r.inventory_id
  JOIN film f ON f.film_id = i.film_id
  WHERE f.title = 'ACADEMY DINOSAUR'
);

-- Films with actors who played in > 10 films
SELECT f.film_id, f.title
FROM film f
WHERE f.film_id IN (
  SELECT fa.film_id
  FROM film_actor fa
  WHERE fa.actor_id IN (
    SELECT actor_id FROM film_actor GROUP BY actor_id HAVING COUNT(*) > 10
  )
);

