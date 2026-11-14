---
theme: default
title: "Day 15 · Advanced SQL"
colorSchema: dark
class: text-left
transition: slide-left
mdc: true
canvasWidth: 980
aspectRatio: 16/9
fonts:
  sans: Space Grotesk
  mono: JetBrains Mono
  provider: none
drawings:
  enabled: false
download: false
lineNumbers: false
layout: cover
---

<div class="cover-frame"></div>

<div class="eyebrow">// Dibimbing SQL · Day 15</div>

# Advanced <span class="hl">SQL Queries</span>

<div class="lead">Subquery · CTE · Ranking · String & Date Functions</div>

<div class="row mt-8" style="max-width: 680px">
  <div class="card pop"><div class="box-h">Dataset</div><b>dvdrental (PostgreSQL)</b></div>
  <div class="card pop"><div class="box-h">Level</div><b>Advanced</b></div>
</div>

---

<div class="eyebrow">// Agenda</div>

## Hari ini kita cover

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Query Structure</div>

- Subqueries (scalar, IN, FROM)
- CTEs (`WITH` clause)
- Ranking: `ROW_NUMBER`, `RANK`, `DENSE_RANK`

</div>
<div class="card pop">
<div class="box-h">Functions</div>

- String: `LEFT`, `RIGHT`, `SUBSTRING`, `CONCAT`, `UPPER`, `LOWER`, `LENGTH`, `LIKE`
- Date: `NOW`, `DATE_TRUNC`, `EXTRACT`, `INTERVAL`
- Numeric: `ABS`, `ROUND`, `MOD`, `FLOOR`, `CEIL`

</div>
</div>

---

<div class="eyebrow">// Subqueries</div>

## Subquery — Query di Dalam Query

Subquery = query yang berjalan **di dalam** query lain. Dieksekusi dulu, hasilnya dipakai outer query.

```
Tipe subquery:
  WHERE ... IN (SELECT ...)       → multi-row subquery
  WHERE col = (SELECT ...)        → scalar subquery (1 baris, 1 kolom)
  FROM (SELECT ...) AS alias      → derived table
  WHERE EXISTS (SELECT 1 ...)     → existence check
```

---

<div class="eyebrow">// Subquery — IN</div>

## Subquery dengan IN

```sql
-- Customer yang pernah rental 'ACADEMY DINOSAUR'
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE c.customer_id IN (
  SELECT r.customer_id
  FROM rental r
  JOIN inventory i ON i.inventory_id = r.inventory_id
  JOIN film f      ON f.film_id = i.film_id
  WHERE UPPER(f.title) = 'ACADEMY DINOSAUR'
);

-- Film dengan actor yang main di > 10 film
SELECT film_id, title
FROM film
WHERE film_id IN (
  SELECT fa.film_id
  FROM film_actor fa
  WHERE fa.actor_id IN (
    SELECT actor_id FROM film_actor
    GROUP BY actor_id HAVING COUNT(*) > 10
  )
);
```

---

<div class="eyebrow">// Subquery — FROM</div>

## Derived Table (Subquery di FROM)

Subquery di `FROM` bertindak seperti tabel sementara — harus diberi alias.

```sql
-- Top 5 actor paling produktif
SELECT a.actor_id, a.first_name, a.last_name,
       stats.film_count
FROM (
    SELECT fa.actor_id, COUNT(*) AS film_count
    FROM film_actor fa
    GROUP BY fa.actor_id
) AS stats                              -- ← wajib ada alias
JOIN actor a ON a.actor_id = stats.actor_id
ORDER BY stats.film_count DESC
LIMIT 5;
```

Derived table vs CTE: fungsionalnya sama, CTE lebih readable untuk query kompleks.

---

<div class="eyebrow">// CTE</div>

## Common Table Expressions (WITH)

CTE = named subquery yang dideklarasikan di atas query utama. Lebih mudah dibaca, bisa dirujuk berkali-kali.

```sql
-- Top 10 spender
WITH customer_spend AS (
  SELECT customer_id, SUM(amount) AS total_spend
  FROM payment
  GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name,
       cs.total_spend
FROM customer c
JOIN customer_spend cs USING (customer_id)
ORDER BY cs.total_spend DESC
LIMIT 10;
```

Sintaks: `WITH name AS ( subquery ) SELECT ...`

Beberapa CTE bisa dirantai: `WITH a AS (...), b AS (...) SELECT ...`

---

<div class="eyebrow">// CTE — Chained</div>

## CTE Chained + Window Function

```sql
-- Second most recent rental per customer
WITH ranked_rentals AS (
  SELECT
    customer_id,
    rental_id,
    rental_date,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY rental_date DESC
    ) AS rn
  FROM rental
)
SELECT customer_id, rental_id, rental_date
FROM ranked_rentals
WHERE rn = 2            -- baris ke-2 terbaru
ORDER BY customer_id;
```

Pattern klasik: CTE → window function → filter hasilnya dengan `WHERE` di luar.

---

<div class="eyebrow">// Ranking Functions</div>

## ROW_NUMBER · RANK · DENSE_RANK

Ketiga fungsi ini memberi **nomor urut** ke baris. Bedanya di treatment **ties** (nilai sama):

```
Nilai:        10  10  8  7  7  5
ROW_NUMBER:    1   2  3  4  5  6   ← selalu unik, tie dapat nomor berbeda
RANK:          1   1  3  4  4  6   ← tie dapat nomor sama, ada gap
DENSE_RANK:    1   1  2  3  3  4   ← tie dapat nomor sama, TANPA gap
```

---

<div class="eyebrow">// Ranking — Code</div>

## Ranking dalam Praktek

```sql
-- Rank film per category berdasarkan jumlah rental
WITH film_rentals AS (
  SELECT c.name AS category, f.film_id, f.title,
         COUNT(r.rental_id) AS rentals
  FROM category c
  JOIN film_category fc ON fc.category_id = c.category_id
  JOIN film f            ON f.film_id = fc.film_id
  JOIN inventory i       ON i.film_id = f.film_id
  JOIN rental r          ON r.inventory_id = i.inventory_id
  GROUP BY c.name, f.film_id, f.title
)
SELECT category, title, rentals,
  ROW_NUMBER() OVER (PARTITION BY category ORDER BY rentals DESC) AS rn,
  RANK()       OVER (PARTITION BY category ORDER BY rentals DESC) AS rnk,
  DENSE_RANK() OVER (PARTITION BY category ORDER BY rentals DESC) AS drnk
FROM film_rentals
ORDER BY category, rentals DESC
LIMIT 30;
```

---

<div class="eyebrow">// String Functions</div>

## Manipulasi String

```sql
-- LEFT / RIGHT / SUBSTRING
SELECT title,
       LEFT(title, 5)              AS left5,
       RIGHT(title, 4)             AS right4,
       SUBSTRING(title FROM 3 FOR 6) AS sub_3_8
FROM film LIMIT 5;

-- CONCAT / UPPER / LOWER / LENGTH
SELECT CONCAT(first_name, ' ', last_name) AS actor_name,
       UPPER(first_name)   AS upper_name,
       LOWER(last_name)    AS lower_name,
       LENGTH(last_name)   AS len
FROM actor LIMIT 10;

-- REPLACE
SELECT title, REPLACE(title, 'A', '*') AS replaced
FROM film LIMIT 5;

-- ILIKE: case-insensitive LIKE
SELECT title FROM film WHERE title ILIKE 'aca%' LIMIT 5;
```

---

<div class="eyebrow">// Date Functions</div>

## Date & Time

```sql
-- NOW dan INTERVAL
SELECT NOW() AS now_ts,
       NOW() + INTERVAL '7 days'  AS in_7_days,
       NOW() - INTERVAL '3 hours' AS three_hours_ago;

-- DATE_TRUNC: potong ke granularitas tertentu
SELECT DATE_TRUNC('month', payment_date) AS month,
       SUM(amount) AS total_amount
FROM payment
GROUP BY 1 ORDER BY 1;

-- EXTRACT: ambil bagian dari timestamp
SELECT EXTRACT(HOUR FROM payment_date) AS hour_of_day,
       COUNT(*) AS payments
FROM payment GROUP BY 1 ORDER BY 1;

-- Filter satu hari: half-open range (index-friendly)
SELECT payment_id, payment_date, amount
FROM payment
WHERE payment_date >= DATE '2005-05-25'
  AND payment_date <  DATE '2005-05-26';
```

---

<div class="eyebrow">// Numeric Functions</div>

## Math Functions

```sql
SELECT
    42.7           AS raw,
    ABS(-42.7)     AS absolute,     -- nilai absolut
    ROUND(42.7)    AS rounded,      -- 43
    FLOOR(42.7)    AS floored,      -- 42 (bulatkan ke bawah)
    CEIL(42.1)     AS ceiled,       -- 43 (bulatkan ke atas)
    MOD(10, 3)     AS modulo,       -- 1 (sisa bagi)
    SQRT(16)       AS sqrt_16;      -- 4

-- Contoh praktis: hitung rata-rata berbulatkan 2 desimal
SELECT
    customer_id,
    ROUND(AVG(amount), 2) AS avg_payment
FROM payment
GROUP BY customer_id
ORDER BY avg_payment DESC
LIMIT 10;
```

---

<div class="eyebrow">// Summary</div>

## Day 15 — Recap

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Query ✓</div>

- Subquery `IN`, scalar, derived table
- CTE dengan `WITH` — readable, bisa dirantai
- `ROW_NUMBER`, `RANK`, `DENSE_RANK` — treatment ties berbeda

</div>
<div class="card pop">
<div class="box-h">Functions ✓</div>

- String: `LEFT`, `RIGHT`, `SUBSTRING`, `CONCAT`, `UPPER`, `LOWER`, `ILIKE`
- Date: `NOW`, `DATE_TRUNC`, `EXTRACT`, `INTERVAL`
- Numeric: `ROUND`, `FLOOR`, `CEIL`, `ABS`, `MOD`

</div>
</div>

<div class="mt-6 card flat">
<div class="box-h">Next → Day 16</div>
Window Functions: OVER, PARTITION BY, frame clauses, LAG/LEAD
</div>

---
layout: closing
---

<div class="cover-frame"></div>

<div class="eyebrow">// Day 15 · Done</div>

# Lanjut ke <span class="hl">Day 16</span>

<div class="lead mt-4">Window Functions — OVER, PARTITION BY, Frame Clauses</div>
