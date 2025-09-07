-- Ranking window functions on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- Rank films by number of rentals per category
WITH film_rentals AS (
  SELECT c.name AS category,
         f.film_id,
         f.title,
         COUNT(r.rental_id) AS rentals
  FROM category c
  JOIN film_category fc ON fc.category_id = c.category_id
  JOIN film f ON f.film_id = fc.film_id
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental r ON r.inventory_id = i.inventory_id
  GROUP BY c.name, f.film_id, f.title
)
SELECT category,
       title,
       rentals,
       ROW_NUMBER() OVER (PARTITION BY category ORDER BY rentals DESC) AS row_number_rank,
       RANK()       OVER (PARTITION BY category ORDER BY rentals DESC) AS rank_rank,
       DENSE_RANK() OVER (PARTITION BY category ORDER BY rentals DESC) AS dense_rank_rank,
       NTILE(4)     OVER (PARTITION BY category ORDER BY rentals DESC) AS quartile
FROM film_rentals
ORDER BY category, rentals DESC, title
LIMIT 50;

