-- Day 14 - UNION vs UNION ALL Examples (dvdrental)

-- 1) UNION ALL: keep duplicates
SELECT first_name AS entity_name FROM customer
UNION ALL
SELECT title AS entity_name FROM film;

-- 2) UNION: remove duplicates
SELECT first_name AS entity_name FROM customer
UNION
SELECT title AS entity_name FROM film;


