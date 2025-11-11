-- Day 13 - DML Examples (PostgreSQL, dvdrental)
-- Wrapped in a single transaction and rolled back to avoid mutating sample data.

BEGIN;

-- 1) INSERT with RETURNING (actor has no FKs, safe for demo)
INSERT INTO public.actor (first_name, last_name)
VALUES ('TRAIN', 'DEMO')
RETURNING actor_id, first_name, last_name;

-- 2) UPDATE with filter and RETURNING (demonstration only)
-- Increase rental_rate slightly for G/PG rated films
UPDATE public.film
SET rental_rate = rental_rate + 0.50
WHERE rating IN ('G', 'PG')
RETURNING film_id, title, rating, rental_rate;

-- 3) DELETE with USING (remove film_actor rows for our demo actor, if any)
DELETE FROM public.film_actor fa
USING public.actor a
WHERE a.actor_id = fa.actor_id
  AND a.first_name = 'TRAIN'
  AND a.last_name = 'DEMO'
RETURNING fa.actor_id, fa.film_id;

-- 4) INSERT ... ON CONFLICT (UPSERT) on PK
-- Pick a high, unlikely actor_id to avoid clashing with existing ids
INSERT INTO public.actor (actor_id, first_name, last_name)
VALUES (99999, 'UPSERT', 'DEMO')
ON CONFLICT (actor_id) DO UPDATE
SET first_name = EXCLUDED.first_name,
    last_name  = EXCLUDED.last_name,
    last_update = now()
RETURNING actor_id, first_name, last_name;

-- 5) SELECT aggregate with JOIN and ORDER/LIMIT
-- Top 5 customers by number of rentals
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS num_rentals
FROM public.customer c
JOIN public.rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY num_rentals DESC, c.customer_id
LIMIT 5;

-- 6) INSERT INTO a custom table defined in DDL examples (if present)
-- Note: This depends on day_13/examples/ddl.sql having been run.
INSERT INTO public.customer_note (customer_id, note)
SELECT customer_id, 'Called support about late return'
FROM public.customer
ORDER BY customer_id
LIMIT 1
RETURNING customer_id, note, created_at;

ROLLBACK;


