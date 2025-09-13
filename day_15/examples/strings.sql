-- String functions on dvdrental
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- LEFT: first 5 chars of film title
SELECT title, LEFT(title, 5) AS left5
FROM film
ORDER BY film_id
LIMIT 10;

-- RIGHT: last 4 chars of film title
SELECT title, RIGHT(title, 4) AS right4
FROM film
ORDER BY film_id
LIMIT 10;

-- SUBSTRING: chars 3..8
SELECT title, SUBSTRING(title FROM 3 FOR 6) AS sub_3_8
FROM film
ORDER BY film_id
LIMIT 10;

-- REPLACE: replace 'A' with '*'
SELECT title, REPLACE(title, 'A', '*') AS replaced
FROM film
ORDER BY film_id
LIMIT 10;

-- CONCAT: actor full name
SELECT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor
ORDER BY actor_id
LIMIT 10;

-- UPPER/LOWER
SELECT title, UPPER(title) AS upper_title, LOWER(title) AS lower_title
FROM film
ORDER BY film_id
LIMIT 5;

-- LENGTH of title
SELECT title, LENGTH(title) AS title_len
FROM film
ORDER BY title_len DESC, title
LIMIT 10;


-- LIKE: titles starting with 'A'
SELECT title
FROM film
WHERE title LIKE 'A%'
ORDER BY film_id
LIMIT 10;

-- LIKE with wildcards: '%' any length, '_' single char
-- Example: titles ending with 'MAN'
SELECT title
FROM film
WHERE title LIKE '%MAN'
ORDER BY film_id
LIMIT 10;

-- ILIKE: case-insensitive pattern match
-- Example: titles starting with 'aca' regardless of case
SELECT title
FROM film
WHERE title ILIKE 'aca%'
ORDER BY film_id
LIMIT 10;

-- NOT LIKE: exclude titles containing 'THE'
SELECT title
FROM film
WHERE title NOT LIKE '%THE%'
ORDER BY film_id
LIMIT 10;

