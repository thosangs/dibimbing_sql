-- Day 13 Exercises - dvdrental
-- Write your answers below each TODO. Use IF EXISTS/IF NOT EXISTS where appropriate.
-- You can test safely using BEGIN ... ROLLBACK; if you don't want to persist changes.

-- 1) DDL: Create a table to store per-customer tags (one tag per row)
-- Columns: customer_id (FK to customer.customer_id), tag (varchar), created_at timestamptz default now()
-- Primary key should ensure no duplicate tag for the same customer at the same timestamp.
-- TODO: write CREATE TABLE statement


-- 2) DDL: Add a nullable column imdb_url (text) to film, with a CHECK that enforces http/https URLs or NULL.
-- If a similar constraint exists, skip creation.
-- TODO: write ALTER TABLE and constraint creation guarded by existence checks


-- 3) DDL: Create a partial index on rental(rental_date) only for rows where return_date IS NULL.
-- TODO: write CREATE INDEX statement


-- 4) DML: Insert a new actor named ('PRACTICE','USER'), return the new actor_id. Then DELETE that actor.
-- Wrap both in one transaction so final state remains unchanged.
-- TODO: write BEGIN; INSERT ... RETURNING; DELETE ...; ROLLBACK;


-- 5) DML: Upsert a category with category_id=99998 and name='PRACTICE'.
-- On conflict of PK, update the name to 'PRACTICE-UPDATED'. Return the final id+name.
-- TODO: write INSERT ... ON CONFLICT DO UPDATE ... RETURNING ...


-- 6) Types: Create a table called typing_lab demonstrating at least 6 types:
-- char(3), varchar(20), text, boolean, integer, numeric(8,2), date, timestamptz, interval
-- Insert at least 2 rows showing CHAR padding, numeric rounding, and interval math.
-- TODO: write DDL and DML


-- 7) Types: Select from typing_lab showing:
-- - length for the char column vs trimmed
-- - extended_price as qty * price (rounded to 2 decimals)
-- - created_on + duration
-- TODO: write SELECT


-- 8) Materialization: Using a CTE, compute top 5 films by number of rentals.
-- Return columns: film_id, title, num_rentals. Order by num_rentals desc.
-- TODO: write WITH ... SELECT ...


-- 9) Materialization: Create a temporary table tmp_customer_activity with customer_id and rentals_last_30d.
-- Populate from rental data. Then select top 5 customers. Finally, drop the temp table.
-- TODO: write CREATE TEMP TABLE AS ... ; SELECT ... ; DROP TABLE ...


-- 10) Materialization: Create a materialized view mv_top_customers_7d that stores top customers by rentals in last 7 days.
-- Then REFRESH it, select 10 rows, and drop it.
-- TODO: write CREATE MATERIALIZED VIEW ... ; REFRESH ... ; SELECT ... ; DROP ...


