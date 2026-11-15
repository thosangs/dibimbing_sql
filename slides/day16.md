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
SELECT
  customer_id, rental_id, rental_date,
  FIRST_VALUE(rental_date) OVER (
    PARTITION BY customer_id ORDER BY rental_date
  ) AS first_rental,
  LAST_VALUE(rental_date) OVER (
    PARTITION BY customer_id ORDER BY rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS last_rental     -- ← frame wajib
FROM rental
ORDER BY customer_id, rental_date LIMIT 20;
```

> `LAST_VALUE` butuh frame `UNBOUNDED FOLLOWING` — default frame hanya sampai current row.

---

<div class="eyebrow">// Aggregate as Window</div>

## SUM · AVG · COUNT sebagai Window

```sql
SELECT customer_id, payment_id, payment_date, amount,

  -- Moving average: rata-rata 3 payment terakhir
  AVG(amount) OVER (
    PARTITION BY customer_id ORDER BY payment_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS avg_last_3,

  -- Running total (kumulatif)
  SUM(amount) OVER (
    PARTITION BY customer_id ORDER BY payment_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total

FROM payment
ORDER BY customer_id, payment_date LIMIT 30;
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

<div class="eyebrow">// Frame Clauses — Visual</div>

## Frame = "Jendela" di dalam Partition

<div style="font-size:0.82rem">

Contoh: 5 baris payment customer\_id=1, diurutkan payment\_date.

| # | amount | ROWS 1 PREC→CUR | RANGE CUR→CUR (kalau ada ties) | GROUPS 1 PREC→CUR |
|---|--------|-----------------|-------------------------------|-------------------|
| 1 | 2.99 | **1** | **1** | **1** |
| 2 | 2.99 | **1,2** | **1,2** (sama hari) | **1,2** (1 group) |
| 3 | 4.99 | **2,3** | **3** | **1,2,3** (2 groups) |
| 4 | 0.99 | **3,4** | **4** | **3,4** |
| 5 | 4.99 | **4,5** | **5** | **4,5** |

</div>

<div class="row mt-2">
<div class="card flat" style="font-size:0.8rem;flex:1"><b>ROWS</b> — posisi fisik. Selalu tepat N baris, tidak peduli nilai.</div>
<div class="card flat" style="font-size:0.8rem;flex:1"><b>RANGE</b> — nilai ORDER BY. Semua baris dengan nilai <em>sama</em> masuk sekaligus.</div>
<div class="card flat" style="font-size:0.8rem;flex:1"><b>GROUPS</b> — peer group. 1 "group" = semua baris dengan nilai ORDER BY identik, dihitung sebagai 1 step.</div>
</div>

---

<div class="eyebrow">// Frame Clauses — ROWS</div>

## ROWS — Berdasarkan Posisi Fisik

```sql
-- ROWS: selalu tepat N baris, tidak peduli nilai ORDER BY
WITH p AS (
  SELECT customer_id, payment_id,
         DATE_TRUNC('day', payment_date) AS day, amount
  FROM payment
)
SELECT customer_id, payment_id, day, amount,
  SUM(amount) OVER (
    PARTITION BY customer_id ORDER BY day
    ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
  ) AS rows_sum_2,       -- selalu: baris ini + 1 baris sebelumnya
  SUM(amount) OVER (
    PARTITION BY customer_id ORDER BY day
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS rows_running      -- running total kumulatif
FROM p ORDER BY customer_id, day, payment_id LIMIT 20;
```

> Kalau ada 5 payment di hari yang sama, `ROWS 1 PRECEDING` tetap hanya ambil **1 baris** — yang persis di atasnya secara fisik.

---

<div class="eyebrow">// Frame Clauses — RANGE dengan Ties</div>

## RANGE — Semua Baris dengan Nilai Sama

```sql
-- RANGE: semua baris dengan nilai ORDER BY identik masuk sekaligus
WITH p AS (
  SELECT customer_id, payment_id,
         DATE_TRUNC('day', payment_date) AS day, amount
  FROM payment
)
SELECT customer_id, payment_id, day, amount,
  SUM(amount) OVER (
    PARTITION BY customer_id ORDER BY day
    RANGE BETWEEN CURRENT ROW AND CURRENT ROW
  ) AS range_same_day,   -- total semua payment di hari yang SAMA
  SUM(amount) OVER (
    PARTITION BY customer_id ORDER BY day
    -- default frame = RANGE UNBOUNDED PRECEDING TO CURRENT ROW
  ) AS range_default     -- running total (tapi bisa aneh kalau ada ties!)
FROM p ORDER BY customer_id, day, payment_id LIMIT 20;
```

> **Gotcha**: `RANGE` default bisa counter-intuitive — kalau ada 5 payment satu hari, `RANGE CURRENT ROW` ambil semua 5 sekaligus. Pakai `ROWS` kalau ingin N baris fisik.

---

<div class="eyebrow">// Frame Clauses — GROUPS</div>

## GROUPS — Frame Berdasarkan Peer Group

`GROUPS` dihitung per peer group, bukan per baris. Cocok untuk data yang sudah diagregat per tanggal/periode.

```sql
-- Contoh: total payment per hari, lalu rolling sum 3 hari terakhir
SELECT
  customer_id,
  DATE_TRUNC('day', payment_date)::date AS pay_day,
  SUM(amount)                           AS daily_total,

  -- GROUPS 2 PRECEDING → ambil 3 kelompok hari (hari ini + 2 hari sebelumnya)
  SUM(SUM(amount)) OVER (
    PARTITION BY customer_id
    ORDER BY DATE_TRUNC('day', payment_date)
    GROUPS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS rolling_3day

FROM payment
GROUP BY customer_id, DATE_TRUNC('day', payment_date)
ORDER BY customer_id, pay_day
LIMIT 20;
```

> `GROUPS` baru ada di PostgreSQL 11+. Jika ada 3 payment di hari yang sama, `GROUPS 1 PRECEDING` tetap hanya "1 langkah mundur", bukan "3 baris mundur".

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

<div class="eyebrow">// NoSQL · MongoDB</div>

## MongoDB — Kenapa Ada?

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Dokumen, bukan tabel</div>

- Data disimpan sebagai **JSON/BSON**
- Schema fleksibel — tiap dokumen bisa beda field
- Cocok untuk: katalog produk, event log, profil user, review

</div>
<div class="card pop">
<div class="box-h">Atlas playground</div>

Dataset kita: **`sample_mflix`**

Collection `movies` — 23 ribu film dengan field:
`title`, `year`, `rated`, `runtime`, `genres`, `imdb.rating`, `directors`

</div>
</div>

---

<div class="eyebrow">// MongoDB · Basic Find</div>

## `find()` — Ambil Dokumen

```js
// Semua film (limit 20 otomatis di Atlas UI)
db.movies.find({})

// Proyeksi — pilih field yang mau ditampilkan
db.movies.find(
  {},
  { title: 1, year: 1, "imdb.rating": 1, _id: 0 }
)

// Sort + Limit
db.movies.find(
  {},
  { title: 1, year: 1, _id: 0 }
).sort({ year: -1 }).limit(10)
```

> `1` = tampilkan, `0` = sembunyikan. `_id` selalu muncul kecuali di-set `0`.

---

<div class="eyebrow">// MongoDB · Filter</div>

## Filter — Operator Perbandingan

```js
// Film setelah tahun 2000 dengan rating IMDb > 8
db.movies.find({
  year: { $gt: 2000 },
  "imdb.rating": { $gt: 8 }
}, { title: 1, year: 1, "imdb.rating": 1, _id: 0 })

// $in — film dengan genre tertentu
db.movies.find({
  genres: { $in: ["Action", "Thriller"] }
}, { title: 1, genres: 1, _id: 0 }).limit(10)

// $regex — cari judul mengandung kata
db.movies.find({
  title: { $regex: "love", $options: "i" }
}, { title: 1, year: 1, _id: 0 }).limit(10)
```

---

<div class="eyebrow">// MongoDB · Filter Lanjutan</div>

## Filter — Operator Logika

```js
// $or — bisa juga pakai $and, $nor
db.movies.find({
  $or: [
    { rated: "G" },
    { rated: "PG" }
  ],
  year: { $gte: 2000 }
}, { title: 1, rated: 1, year: 1, _id: 0 })

// $exists + $ne — field ada dan bukan null
db.movies.find({
  "tomatoes.viewer.rating": { $exists: true, $ne: null },
  runtime: { $lte: 90 }
}, { title: 1, runtime: 1, "tomatoes.viewer.rating": 1, _id: 0 })
  .sort({ runtime: 1 }).limit(10)
```

---

<div class="eyebrow">// MongoDB · Aggregation</div>

## `aggregate()` — Pipeline seperti SQL

```js
// GROUP BY genres — hitung jumlah film per genre
db.movies.aggregate([
  { $unwind: "$genres" },
  { $group: {
      _id: "$genres",
      total_films: { $sum: 1 },
      avg_rating: { $avg: "$imdb.rating" },
      avg_runtime: { $avg: "$runtime" }
  }},
  { $sort: { total_films: -1 } },
  { $limit: 10 }
])
```

> `$unwind` — pecah array field (genres) jadi baris terpisah.
> Setara SQL: `GROUP BY genre` setelah `UNNEST`.

---

<div class="eyebrow">// MongoDB · Math Functions</div>

## Fungsi Matematika dalam Aggregation

```js
// $sum, $avg, $min, $max per dekade
db.movies.aggregate([
  { $match: { "imdb.rating": { $exists: true, $gt: 0 } } },
  { $group: {
      _id: { $multiply: [{ $floor: { $divide: ["$year", 10] } }, 10] },
      film_count: { $sum: 1 },
      avg_imdb:   { $avg: "$imdb.rating" },
      max_imdb:   { $max: "$imdb.rating" },
      min_imdb:   { $min: "$imdb.rating" },
      total_votes:{ $sum: "$imdb.votes" }
  }},
  { $sort: { _id: 1 } }
])
```

> `_id` di `$group` = kolom GROUP BY. Bisa ekspresi, bukan hanya field.

---

<div class="eyebrow">// MongoDB · $project</div>

## `$project` — Computed Fields

```js
// Tambah field baru: rating_category dan age_of_film
db.movies.aggregate([
  { $match: { year: { $gte: 1990 }, "imdb.rating": { $gt: 0 } } },
  { $project: {
      title: 1,
      year: 1,
      imdb_rating: "$imdb.rating",
      age_years: { $subtract: [2024, "$year"] },
      rating_cat: {
        $switch: { branches: [
          { case: { $gte: ["$imdb.rating", 8] }, then: "Great" },
          { case: { $gte: ["$imdb.rating", 6] }, then: "Good" }
        ], default: "Average" }
      },
      _id: 0
  }},
  { $sort: { imdb_rating: -1 } },
  { $limit: 15 }
])
```

---

<div class="eyebrow">// NoSQL vs SQL · Perbandingan</div>

## Ekuivalensi MongoDB ↔ SQL

<div class="row mt-4" style="font-size:0.85rem">
<div class="card flat" style="flex:1">
<div class="box-h">SQL</div>

```sql
SELECT title, year
FROM movies
WHERE year > 2000
ORDER BY year DESC
LIMIT 10;
```

```sql
SELECT genre, COUNT(*), AVG(rating)
FROM movies
GROUP BY genre
HAVING COUNT(*) > 50;
```

</div>
<div class="card flat" style="flex:1">
<div class="box-h">MongoDB MQL</div>

```js
db.movies.find(
  { year: { $gt: 2000 } },
  { title: 1, year: 1, _id: 0 }
).sort({ year: -1 }).limit(10)
```

```js
db.movies.aggregate([
  { $unwind: "$genres" },
  { $group: { _id: "$genres",
      count: { $sum: 1 },
      avg_rating: { $avg: "$imdb.rating" }}},
  { $match: { count: { $gt: 50 } }}
])
```

</div>
</div>

---
layout: closing
---

<div class="cover-frame"></div>

<div class="eyebrow">// Day 16 · Done</div>

# Lanjut ke <span class="hl">Day 17</span>

<div class="lead mt-4">Live Coding — The New Release Push</div>
