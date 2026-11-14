---
theme: default
title: "Day 16 · Window Functions"
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

<div class="eyebrow">// Dibimbing SQL · Day 16</div>

# Window <span class="hl">Functions</span>

<div class="lead">OVER · PARTITION BY · Frame Clauses · LAG/LEAD</div>

<div class="row mt-8" style="max-width: 680px">
  <div class="card pop"><div class="box-h">Dataset</div><b>dvdrental (PostgreSQL)</b></div>
  <div class="card pop"><div class="box-h">Level</div><b>Advanced</b></div>
</div>

---

<div class="eyebrow">// Agenda</div>

## Hari ini kita cover

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Window Functions</div>

- Apa itu & bedanya dari GROUP BY
- `OVER (PARTITION BY ... ORDER BY ...)`
- Frame clause: `ROWS` / `RANGE` / `GROUPS`

</div>
<div class="card pop">
<div class="box-h">Function Types</div>

- **Ranking**: `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE`
- **Navigation**: `LAG`, `LEAD`, `FIRST_VALUE`, `LAST_VALUE`
- **Aggregate**: `SUM`, `AVG`, `COUNT` as window

</div>
<div class="card pop">
<div class="box-h">Case Study</div>

Business analytics di dvdrental:
running totals, MoM, cohort, churn signals

</div>
</div>

---

<div class="eyebrow">// What is a Window Function</div>

## Aggregate vs Window

```
-- GROUP BY: collapse semua baris → 1 output per group
SELECT customer_id, SUM(amount) AS total
FROM payment
GROUP BY customer_id;
-- Output: 1 baris per customer

-- WINDOW: kalkulasi tanpa collapse baris
SELECT customer_id, payment_id, amount,
       SUM(amount) OVER (PARTITION BY customer_id) AS total_per_customer
FROM payment;
-- Output: semua baris tetap ada, + kolom hasil kalkulasi
```

> Window function = compute **across related rows**, tapi baris tetap utuh.

---

<div class="eyebrow">// OVER Clause</div>

## Anatomi OVER

```
FUNCTION() OVER (
  PARTITION BY <kolom>     -- bagi ke grup (opsional)
  ORDER BY <kolom>         -- urutan dalam grup (opsional tapi penting)
  ROWS/RANGE/GROUPS BETWEEN <start> AND <end>  -- frame (opsional)
)
```

```sql
-- Contoh: running total payment per customer
SELECT
  customer_id,
  payment_date,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id    -- reset tiap customer
    ORDER BY payment_date       -- kumulatif secara waktu
  ) AS running_total
FROM payment
ORDER BY customer_id, payment_date
LIMIT 20;
```

---

<div class="eyebrow">// Ranking</div>

## ROW_NUMBER · RANK · DENSE_RANK · NTILE

```sql
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
  ROW_NUMBER() OVER (PARTITION BY category ORDER BY rentals DESC) AS row_num,
  RANK()       OVER (PARTITION BY category ORDER BY rentals DESC) AS rank_with_gaps,
  DENSE_RANK() OVER (PARTITION BY category ORDER BY rentals DESC) AS rank_no_gaps,
  NTILE(4)     OVER (PARTITION BY category ORDER BY rentals DESC) AS quartile
FROM film_rentals
ORDER BY category, rentals DESC
LIMIT 30;
```

`NTILE(n)` — bagi baris ke n bucket berukuran (hampir) sama.

---

<div class="eyebrow">// Navigation — LAG / LEAD</div>

## Akses Baris Sebelum / Sesudah

`LAG(col, n)` → lihat n baris ke belakang. `LEAD(col, n)` → n baris ke depan.

```sql
WITH r AS (
  SELECT
    customer_id,
    rental_id,
    rental_date,
    LAG(rental_date)  OVER (PARTITION BY customer_id ORDER BY rental_date)
      AS prev_rental_date,
    LEAD(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)
      AS next_rental_date
  FROM rental
)
SELECT customer_id, rental_date, prev_rental_date, next_rental_date,
       -- hitung jarak ke rental berikutnya
       EXTRACT(day FROM next_rental_date - rental_date) AS days_to_next
FROM r
ORDER BY customer_id, rental_date
LIMIT 30;
```

---

<div class="eyebrow">// Navigation — FIRST/LAST/NTH</div>

## FIRST_VALUE · LAST_VALUE · NTH_VALUE

```sql
WITH r AS (
  SELECT
    customer_id, rental_id, rental_date,
    FIRST_VALUE(rental_date) OVER (
      PARTITION BY customer_id ORDER BY rental_date
    ) AS first_rental,
    LAST_VALUE(rental_date) OVER (
      PARTITION BY customer_id ORDER BY rental_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING  -- penting!
    ) AS last_rental,
    NTH_VALUE(rental_date, 2) OVER (
      PARTITION BY customer_id ORDER BY rental_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS second_rental
  FROM rental
)
SELECT * FROM r ORDER BY customer_id, rental_date LIMIT 20;
```

> `LAST_VALUE` butuh frame `UNBOUNDED FOLLOWING` — tanpanya, default frame hanya sampai current row.

---

<div class="eyebrow">// Aggregate as Window</div>

## SUM · AVG · COUNT sebagai Window

```sql
SELECT customer_id, payment_id, payment_date, amount,

  -- Moving average: rata-rata 3 payment terakhir (ROWS frame)
  AVG(amount) OVER (
    PARTITION BY customer_id
    ORDER BY payment_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS avg_last_3,

  -- Cumulative sum (running total)
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY payment_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total,

  -- Partition total (sama untuk semua baris satu customer)
  SUM(amount) OVER (PARTITION BY customer_id) AS total_per_customer

FROM payment
ORDER BY customer_id, payment_date
LIMIT 50;
```

---

<div class="eyebrow">// Frame Clauses</div>

## ROWS · RANGE · GROUPS

```
ROWS:   frame berdasarkan posisi fisik baris
RANGE:  frame berdasarkan nilai (baris dengan nilai ORDER BY sama masuk semua)
GROUPS: frame berdasarkan peer groups (nilai ORDER BY yang identik)

Sintaks:
  ROWS  BETWEEN <start> AND <end>
  RANGE BETWEEN <start> AND <end>

Keyword start/end:
  UNBOUNDED PRECEDING  → dari awal partition
  n PRECEDING          → n baris sebelum
  CURRENT ROW          → baris saat ini
  n FOLLOWING          → n baris setelah
  UNBOUNDED FOLLOWING  → sampai akhir partition
```

---

<div class="eyebrow">// Frame Clauses — Code</div>

## ROWS vs RANGE Demo

```sql
SELECT customer_id, payment_id, payment_date, amount,

  -- ROWS: tepat 2 baris sebelum + current
  SUM(amount) OVER (
    PARTITION BY customer_id ORDER BY payment_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS sum_rows_last_3,

  -- RANGE: semua baris dengan payment_date yang sama (ke detik yang sama)
  SUM(amount) OVER (
    PARTITION BY customer_id ORDER BY payment_date
    RANGE BETWEEN CURRENT ROW AND CURRENT ROW
  ) AS sum_same_timestamp

FROM payment
ORDER BY customer_id, payment_date
LIMIT 50;
```

---

<div class="eyebrow">// Case Study</div>

## Running Total & Month-over-Month

```sql
-- Running total spend per customer
SELECT customer_id, payment_id, payment_date, amount,
       SUM(amount) OVER (
         PARTITION BY customer_id ORDER BY payment_date
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cum_spend
FROM payment ORDER BY customer_id, payment_date LIMIT 30;
```

```sql
-- MoM: bandingkan rentals bulan ini vs bulan lalu
WITH monthly AS (
  SELECT DATE_TRUNC('month', rental_date) AS month,
         COUNT(*) AS rentals
  FROM rental GROUP BY 1
)
SELECT month, rentals,
       LAG(rentals) OVER (ORDER BY month)              AS prev_month,
       ROUND(100.0 * (rentals - LAG(rentals) OVER (ORDER BY month))
             / NULLIF(LAG(rentals) OVER (ORDER BY month), 0), 1) AS pct_change
FROM monthly ORDER BY month;
```

---

<div class="eyebrow">// Summary</div>

## Day 16 — Recap

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Konsep ✓</div>

- Window function: kalkulasi lintas baris tanpa collapse
- `OVER (PARTITION BY ... ORDER BY ... FRAME)`
- `ROWS` = posisi fisik; `RANGE` = nilai; wajib set frame untuk `LAST_VALUE`

</div>
<div class="card pop">
<div class="box-h">Functions ✓</div>

- Ranking: `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE`
- Navigation: `LAG`, `LEAD`, `FIRST_VALUE`, `LAST_VALUE`, `NTH_VALUE`
- Aggregate: `SUM/AVG/COUNT` sebagai window (running totals, moving avg)

</div>
</div>

<div class="mt-6 card flat">
<div class="box-h">Next → Day 17</div>
Live coding: cohort analysis, churn, rolling windows — story-driven
</div>

---
layout: closing
---

<div class="cover-frame"></div>

<div class="eyebrow">// Day 16 · Done</div>

# Lanjut ke <span class="hl">Day 17</span>

<div class="lead mt-4">Live Coding — The New Release Push</div>
