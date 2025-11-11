-- Day 13 - DDL Examples (PostgreSQL, dvdrental)
-- Safe to run multiple times (uses IF EXISTS/IF NOT EXISTS)

-- 1) CREATE TABLE with PK and FK referencing dvdrental.customer
DROP TABLE IF EXISTS public.customer_note CASCADE;
CREATE TABLE public.customer_note (
    customer_id integer NOT NULL REFERENCES public.customer(customer_id),
    note text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (customer_id, created_at)
);

-- 2) ALTER TABLE (add column and a CHECK constraint) on an existing dvdrental table
-- Adds a nullable column and a simple URL format check (only if not already added)
ALTER TABLE public.film
    ADD COLUMN IF NOT EXISTS imdb_url text;
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'film_imdb_url_chk'
    ) THEN
        ALTER TABLE public.film
            ADD CONSTRAINT film_imdb_url_chk
            CHECK (imdb_url IS NULL OR imdb_url ~ '^https?://');
    END IF;
END$$;

-- 3) CREATE INDEX (partial index) on dvdrental.rental
-- Useful to speed up queries for outstanding rentals (where return_date IS NULL)
CREATE INDEX IF NOT EXISTS idx_rental_outstanding
    ON public.rental (rental_date)
    WHERE return_date IS NULL;

-- 4) CREATE TABLE ... RENAME TABLE ... DROP TABLE (demonstrate object lifecycle)
DROP TABLE IF EXISTS public.training_scratch;
CREATE TABLE public.training_scratch (
    id serial PRIMARY KEY,
    label text
);
ALTER TABLE public.training_scratch RENAME TO training_scratch_renamed;
DROP TABLE IF EXISTS public.training_scratch_renamed;

-- 5) CREATE TABLE AS ... TRUNCATE ... DROP (demonstrate truncate semantics)
DROP TABLE IF EXISTS public.tmp_actor_copy;
CREATE TABLE public.tmp_actor_copy AS
SELECT * FROM public.actor WITH NO DATA;  -- structure only

TRUNCATE TABLE public.tmp_actor_copy;     -- safe: table is empty
DROP TABLE IF EXISTS public.tmp_actor_copy;

-- 6) ALTER TABLE (add/dropped column) on our own table to keep demo isolated
ALTER TABLE public.customer_note
    ADD COLUMN IF NOT EXISTS important boolean DEFAULT false;
ALTER TABLE public.customer_note
    DROP COLUMN IF EXISTS important;

-- 7) CREATE UNIQUE INDEX on dvdrental.category(name) if not present
-- (Some dvdrental snapshots already enforce unique names; this guards duplicates)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE schemaname = 'public'
          AND indexname = 'ux_category_name'
    ) THEN
        EXECUTE 'CREATE UNIQUE INDEX ux_category_name ON public.category (name)';
    END IF;
END$$;


