---
theme: default
title: "Day 14 · Basic & Intermediate SQL"
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

<div class="eyebrow">// Dibimbing SQL · Day 14</div>

# Basic & Intermediate <span class="hl">SQL</span>

<div class="lead">SELECT · Filter · Aggregate · JOIN · UNION</div>

<div class="row mt-8" style="max-width: 680px">
  <div class="card pop"><div class="box-h">Dataset</div><b>dvdrental (PostgreSQL)</b></div>
  <div class="card pop"><div class="box-h">Level</div><b>Intermediate</b></div>
</div>

---

<div class="eyebrow">// Agenda</div>

## Hari ini kita cover

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Filtering</div>

`WHERE` · `AND` / `OR`

`IN` · `BETWEEN` · `LIKE` · `IS NULL`

</div>
<div class="card pop">
<div class="box-h">Aggregation</div>

`COUNT` · `SUM` · `AVG` · `MAX` · `MIN`

`GROUP BY` · `HAVING`

</div>
<div class="card pop">
<div class="box-h">Conditional & Join</div>

`CASE WHEN` · `COALESCE`

`INNER` · `LEFT` · `RIGHT` · `FULL` · `CROSS`

`UNION` · `UNION ALL`

</div>
</div>

---

<div class="eyebrow">// WHERE</div>

## Filtering dengan WHERE

`WHERE` menyaring baris **sebelum** data dikembalikan. Dievaluasi per baris.

```sql
-- AND: kedua kondisi harus true
SELECT film_id, title, rental_rate, length
FROM film
WHERE rental_rate > 3.99
  AND length < 50
ORDER BY rental_rate DESC
LIMIT 20;

-- OR: salah satu kondisi cukup
SELECT customer_id, first_name, last_name, co.country
FROM customer c
JOIN address a   ON a.address_id = c.address_id
JOIN city ci     ON ci.city_id = a.city_id
JOIN country co  ON co.country_id = ci.country_id
WHERE co.country = 'Indonesia'
   OR c.customer_id = 358;
```

---

<div class="eyebrow">// WHERE — Advanced</div>

## IN · BETWEEN · LIKE · IS NULL

```sql
-- IN: cocokkan ke satu set nilai
SELECT f.film_id, f.title, c.name AS category
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c       ON c.category_id = fc.category_id
WHERE c.name IN ('Action', 'Comedy', 'Family');

-- BETWEEN: inklusif di kedua ujung
SELECT payment_id, customer_id, amount, payment_date
FROM payment
WHERE payment_date BETWEEN '2005-05-01' AND '2005-06-01';

-- LIKE: % = any sequence, _ = single char
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'D%';     -- mulai dengan D

-- IS NULL / IS NOT NULL
SELECT film_id, title, description
FROM film
WHERE description IS NULL;
```

---

<div class="eyebrow">// Aggregation</div>

## GROUP BY & Aggregate Functions

Aggregate functions **meringkas** banyak baris menjadi satu nilai per group.

```
SELECT → GROUP BY → HAVING → ORDER BY → LIMIT
```

```sql
-- Semua transaksi (tanpa group)
SELECT COUNT(*) AS total_tx, AVG(amount) AS avg_payment,
       SUM(amount) AS total_revenue, MAX(amount) AS max_payment
FROM payment;

-- Grouped: total per customer
SELECT customer_id,
       COUNT(*)       AS num_payments,
       SUM(amount)    AS total_spent,
       AVG(amount)    AS avg_payment
FROM payment
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 20;
```

---

<div class="eyebrow">// HAVING</div>

## Filter Setelah Agregasi

`WHERE` bekerja **sebelum** GROUP BY. `HAVING` bekerja **sesudah** — memfilter groups.

```sql
-- Hanya customer yang bayar >= 30 kali
SELECT customer_id,
       COUNT(*) AS num_payments,
       SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING COUNT(*) >= 30
ORDER BY total_spent DESC;

-- Revenue per bulan
SELECT date_trunc('month', payment_date) AS month,
       COUNT(*) AS num_transactions,
       SUM(amount) AS revenue
FROM payment
GROUP BY date_trunc('month', payment_date)
ORDER BY month;
```

> Rule: `WHERE` filters rows, `HAVING` filters groups.

---

<div class="eyebrow">// CASE WHEN</div>

## Conditional Logic

`CASE WHEN` membuat nilai baru berdasarkan kondisi — seperti if/else di SQL.

```sql
-- Kategorisasi panjang film
SELECT title, length,
  CASE
    WHEN length <= 50               THEN 'Short'
    WHEN length > 50 AND length <= 120 THEN 'Medium'
    ELSE 'Long'
  END AS length_category
FROM film;

-- Payment tier
SELECT payment_id, amount,
  CASE
    WHEN amount < 2 THEN 'Bronze'
    WHEN amount < 5 THEN 'Silver'
    WHEN amount < 8 THEN 'Gold'
    ELSE 'Platinum'
  END AS tier
FROM payment
LIMIT 50;
```

---

<div class="eyebrow">// COALESCE · GREATEST · LEAST</div>

## NULL Handling & Clamping

```sql
-- COALESCE: kembalikan nilai pertama yang NOT NULL
SELECT customer_id, first_name,
       COALESCE(a.address2, 'N/A') AS address2_label
FROM customer c
JOIN address a ON a.address_id = c.address_id
LIMIT 50;

-- GREATEST/LEAST: pilih max/min dari daftar ekspresi
SELECT payment_id, amount,
       GREATEST(amount, 0)      AS amount_min_zero,  -- floor di 0
       LEAST(amount, 10.00)     AS amount_cap_10     -- cap di 10
FROM payment
LIMIT 50;
```

`COALESCE(x, default)` ≡ `CASE WHEN x IS NOT NULL THEN x ELSE default END`

---

<div class="eyebrow">// JOIN — Diagram</div>

## JOIN Types

```
customer (c)          payment (p)
┌────────────┐        ┌─────────────┐
│ customer_id│        │ customer_id │
│ first_name │        │ amount      │
└─────┬──────┘        └──────┬──────┘
      │                      │
      └──────── JOIN ─────────┘
                ON c.customer_id = p.customer_id

INNER JOIN  → hanya baris yang match di keduanya
LEFT JOIN   → semua dari kiri, NULL jika tidak ada di kanan
RIGHT JOIN  → semua dari kanan, NULL jika tidak ada di kiri
FULL OUTER  → semua baris dari keduanya, NULL di sisi yang kosong
CROSS JOIN  → cartesian product (setiap kombinasi)
```

---

<div class="eyebrow">// JOIN — Code</div>

## INNER · LEFT · RIGHT · FULL · CROSS

<div class="code-sm">

```sql
-- INNER JOIN: customer + payment yang match
SELECT c.customer_id, c.first_name, p.amount
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
LIMIT 10;

-- LEFT JOIN: semua category, film opsional (NULL jika tidak ada)
SELECT c.name AS category, f.title
FROM category c
LEFT JOIN film_category fc ON fc.category_id = c.category_id
LEFT JOIN film f            ON f.film_id = fc.film_id
ORDER BY c.category_id, f.film_id NULLS LAST;

-- FULL OUTER: semua category DAN semua film (baik yang match maupun tidak)
SELECT c.name, f.title
FROM category c
FULL OUTER JOIN film_category fc ON fc.category_id = c.category_id
FULL OUTER JOIN film f            ON f.film_id = fc.film_id;

-- CROSS JOIN: 3 category × 3 film = 9 kombinasi
SELECT c.name, f.title
FROM (SELECT * FROM category LIMIT 3) c
CROSS JOIN (SELECT * FROM film LIMIT 3) f;
```

</div>

---

<div class="eyebrow">// UNION</div>

## UNION vs UNION ALL

`UNION` menggabungkan result sets dari dua query. Kolom harus sama jumlah & tipe.

```sql
-- UNION ALL: gabung semua baris (duplikat tetap ada) — lebih cepat
SELECT customer_id, 'payment' AS source, amount AS value
FROM payment
WHERE amount > 9

UNION ALL

SELECT customer_id, 'rental' AS source, 1.00 AS value
FROM rental
WHERE return_date IS NULL;

-- UNION: deduplicate (buang baris duplikat) — lebih lambat karena sort
SELECT first_name FROM customer
UNION
SELECT first_name FROM actor;
```

> Default: `UNION` = deduplicate. Gunakan `UNION ALL` jika tidak perlu dedup — jauh lebih efisien.

---

<div class="eyebrow">// Summary</div>

## Day 14 — Recap

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Filtering ✓</div>

`WHERE`, `AND/OR`, `IN`, `BETWEEN`, `LIKE`, `IS NULL`

Order eksekusi: `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`

</div>
<div class="card pop">
<div class="box-h">Aggregate & Join ✓</div>

`COUNT/SUM/AVG/MAX/MIN` + `GROUP BY` + `HAVING`

`CASE WHEN`, `COALESCE`, `GREATEST/LEAST`

`INNER/LEFT/RIGHT/FULL/CROSS JOIN`

`UNION ALL` (cepat) vs `UNION` (deduplicate)

</div>
</div>

<div class="mt-6 card flat">
<div class="box-h">Next → Day 15</div>
Subqueries · CTEs · Ranking Functions · String & Date Functions
</div>

---
layout: closing
---

<div class="cover-frame"></div>

<div class="eyebrow">// Day 14 · Done</div>

# Lanjut ke <span class="hl">Day 15</span>

<div class="lead mt-4">Advanced SQL Queries & Data Analysis</div>
