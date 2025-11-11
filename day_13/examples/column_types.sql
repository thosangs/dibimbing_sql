-- Day 13 - Column Types Examples (PostgreSQL)
-- Demonstrates common PostgreSQL types and behaviors

DROP TABLE IF EXISTS public.typing_demo;
CREATE TABLE public.typing_demo (
    id serial PRIMARY KEY,
    code char(5),                              -- fixed-length, space-padded
    name varchar(50),                          -- variable-length with limit
    description text,                          -- unlimited length
    active boolean DEFAULT true,               -- boolean
    qty integer,                               -- 32-bit int
    price numeric(10,2),                       -- fixed precision/scale
    created_on date DEFAULT current_date,      -- date only
    updated_at timestamptz DEFAULT now(),      -- timestamp with time zone
    duration interval                          -- time interval
);

-- 1) Insert demonstrates CHAR padding and NUMERIC rounding
INSERT INTO public.typing_demo (code, name, description, active, qty, price, duration)
VALUES ('AB', 'Widget', 'Two-letter code; price rounds to 2 decimals', true, 10, 12.345, '3 days 4 hours');

-- 2) Insert with boolean variants and timestamp math
INSERT INTO public.typing_demo (code, name, description, active, qty, price, created_on, updated_at, duration)
VALUES ('XYZ12', 'Gadget', 'Boolean from text literal', 't', 0, 199.9, '2024-05-01', now() - interval '1 day', '90 minutes');

-- 3) Insert demonstrating varchar limit
INSERT INTO public.typing_demo (code, name, description, active, qty, price, duration)
VALUES ('CODE5', repeat('N', 50), 'name is exactly 50 chars', false, 5, 1.5, '1 hour');

-- 4) Select shows CHAR padding vs. length, and interval arithmetic
SELECT
    id,
    code,
    length(code)                  AS len_code_char,     -- counts padded spaces
    rtrim(code)                   AS code_trimmed,      -- remove trailing spaces
    char_length(code)             AS char_len_code,     -- same as length for text
    name,
    octet_length(name)            AS bytes_name,
    price,
    price::text                   AS price_as_text,
    created_on,
    updated_at,
    (created_on + duration)       AS created_plus_duration
FROM public.typing_demo
ORDER BY id;

-- 5) Casting, type checks, and numeric operations
SELECT
    id,
    qty::bigint * 1000                    AS qty_milliunits,
    (price * qty)::numeric(12,2)          AS extended_price,
    active::int                           AS active_as_int
FROM public.typing_demo
ORDER BY id;

-- 6) Clean up (optional)
-- DROP TABLE IF EXISTS public.typing_demo;


