-- DML examples on dvdrental (run and then revert safely)
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- Insert a temporary category and link a film
WITH ins AS (
  INSERT INTO category(name) VALUES ('Tutorials') RETURNING category_id
)
INSERT INTO film_category(film_id, category_id)
SELECT f.film_id, ins.category_id
FROM film f, ins
WHERE UPPER(f.title) = 'ACADEMY DINOSAUR';

-- Update: increase rental_rate for that temporary category by 10%
UPDATE film f
SET rental_rate = rental_rate * 1.10
FROM film_category fc
JOIN category c ON c.category_id = fc.category_id
WHERE fc.film_id = f.film_id AND c.name = 'Tutorials';

-- Cleanup: delete the link and category
DELETE FROM film_category USING category c
WHERE film_category.category_id = c.category_id AND c.name = 'Tutorials';

DELETE FROM category WHERE name = 'Tutorials';

