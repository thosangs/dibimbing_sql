-- Day 13 - Materialization Strategies (PostgreSQL)
-- Demonstrates: CTE, derived table, temp table, unlogged table, view, materialized view

-- 1) CTE (Common Table Expression) - typically NOT materialized in Postgres by default
WITH recent_rentals AS (
    SELECT r.rental_id, r.customer_id, r.rental_date
    FROM public.rental r
    WHERE r.rental_date >= now() - interval '60 days'
)
SELECT c.customer_id, c.first_name, c.last_name, COUNT(rr.rental_id) AS rentals_last_60d
FROM public.customer c
LEFT JOIN recent_rentals rr ON rr.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rentals_last_60d DESC, c.customer_id
LIMIT 10;

-- 2) Derived table (subquery in FROM)
SELECT f.film_id, f.title, x.cnt AS rental_count
FROM public.film f
JOIN (
    SELECT i.film_id, COUNT(r.rental_id) AS cnt
    FROM public.inventory i
    JOIN public.rental r ON r.inventory_id = i.inventory_id
    GROUP BY i.film_id
) AS x ON x.film_id = f.film_id
ORDER BY x.cnt DESC, f.film_id
LIMIT 10;

-- 3) Temporary table (session-scoped, auto-dropped at end of session)
DROP TABLE IF EXISTS pg_temp.tmp_top_customers;
CREATE TEMP TABLE tmp_top_customers AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS num_rentals
FROM public.customer c
JOIN public.rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY num_rentals DESC
LIMIT 20;
SELECT * FROM tmp_top_customers ORDER BY num_rentals DESC, customer_id LIMIT 5;
-- Temp table will vanish at session end

-- 4) Unlogged table (faster writes, not WAL-logged; data lost after crash)
DROP TABLE IF EXISTS public.unlogged_rental_counts;
CREATE UNLOGGED TABLE public.unlogged_rental_counts AS
SELECT i.film_id, COUNT(r.rental_id) AS num_rentals
FROM public.inventory i
JOIN public.rental r ON r.inventory_id = i.inventory_id
GROUP BY i.film_id;
-- Use and then clean up
SELECT * FROM public.unlogged_rental_counts ORDER BY num_rentals DESC, film_id LIMIT 5;
DROP TABLE IF EXISTS public.unlogged_rental_counts;

-- 5) View (virtual, not materialized)
DROP VIEW IF EXISTS public.vw_film_rental_counts;
CREATE VIEW public.vw_film_rental_counts AS
SELECT f.film_id, f.title, x.num_rentals
FROM public.film f
LEFT JOIN (
    SELECT i.film_id, COUNT(r.rental_id) AS num_rentals
    FROM public.inventory i
    LEFT JOIN public.rental r ON r.inventory_id = i.inventory_id
    GROUP BY i.film_id
) x ON x.film_id = f.film_id;
SELECT * FROM public.vw_film_rental_counts ORDER BY num_rentals DESC NULLS LAST, film_id LIMIT 10;
DROP VIEW IF EXISTS public.vw_film_rental_counts;

-- 6) Materialized view (physically stored; requires manual refresh)
DROP MATERIALIZED VIEW IF EXISTS public.mv_top_films;
CREATE MATERIALIZED VIEW public.mv_top_films AS
SELECT f.film_id, f.title, x.num_rentals
FROM public.film f
JOIN (
    SELECT i.film_id, COUNT(r.rental_id) AS num_rentals
    FROM public.inventory i
    JOIN public.rental r ON r.inventory_id = i.inventory_id
    GROUP BY i.film_id
) x ON x.film_id = f.film_id
ORDER BY x.num_rentals DESC, f.film_id
WITH NO DATA;  -- define structure quickly first

REFRESH MATERIALIZED VIEW public.mv_top_films;
SELECT * FROM public.mv_top_films LIMIT 10;
DROP MATERIALIZED VIEW IF EXISTS public.mv_top_films;


