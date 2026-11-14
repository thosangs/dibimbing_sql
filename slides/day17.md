---
theme: default
title: "Day 17 · Live Coding"
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

<div class="eyebrow">// Dibimbing SQL · Day 17 · Final</div>

# Live Coding — <span class="hl">The New Release Push</span>

<div class="lead">Cohort · Churn · Rolling Windows · Story-driven Analytics</div>

<div class="row mt-8" style="max-width: 680px">
  <div class="card pop"><div class="box-h">Session</div><b>3 jam</b></div>
  <div class="card pop"><div class="box-h">Structure</div><b>Easy → Medium → Hard</b></div>
  <div class="card pop"><div class="box-h">Dataset</div><b>dvdrental (PostgreSQL)</b></div>
</div>

---

<div class="eyebrow">// Story</div>

## Skenario: New Release Push Campaign

> Kamu adalah analyst di dvdrental chain. Leadership baru saja launch **"New Release Push"** campaign (1 Jul 2005). Mereka mau tahu:
> - Bagaimana growth customer dan engagement?
> - Ada churn? Siapa yang reactivate?
> - Apakah kampanye berhasil?
> - Film mana yang perlu restok?

Kita selesaikan step-by-step dari **Easy → Medium → Hard**, mengikuti alur analitik nyata.

---

<div class="eyebrow">// Teknik yang Digunakan</div>

## Tools & Techniques

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Foundation</div>

`JOIN`, `GROUP BY`, `HAVING`

`CASE WHEN`, conditional aggregation

`DATE_TRUNC`, `EXTRACT`, `INTERVAL`

</div>
<div class="card pop">
<div class="box-h">Structure</div>

Subqueries di `WHERE` dan `FROM`

CTEs (`WITH`) untuk readability

Multi-step pipeline

</div>
<div class="card pop">
<div class="box-h">Advanced</div>

Window functions + custom frames

`ROWS BETWEEN n PRECEDING AND CURRENT ROW`

`RANGE BETWEEN INTERVAL '30 days' PRECEDING AND CURRENT ROW`

</div>
</div>

---

<div class="eyebrow">// dvdrental Schema</div>

## Dataset Reminder

```
customer ──< rental >── inventory >── film >── film_category >── category
    │            │
    └──< payment │
                 └── (return_date IS NULL = masih dipinjam)

Key tables:
  rental      (rental_id, customer_id, inventory_id, rental_date, return_date)
  payment     (payment_id, customer_id, amount, payment_date)
  film        (film_id, title, length, rating, rental_rate)
  inventory   (inventory_id, film_id, store_id)
  customer    (customer_id, first_name, last_name, address_id)
  category    (category_id, name)

Connect:
  psql "postgresql://user:password@localhost:5432/dvdrental"
```

---

<div class="eyebrow">// Easy (E1–E4)</div>

## Easy Analytics — Bagian 1

<div class="row mt-4">
<div class="card pop">
<div class="box-h">E1 — Daily Rentals Trend</div>

Hitung total rentals per hari, 14 hari terakhir.

Hint: `DATE_TRUNC('day', rental_date)` + `GROUP BY`

</div>
<div class="card pop">
<div class="box-h">E2 — Top 10 Films</div>

Film paling banyak dirental. Return `film_id`, `title`, total rentals.

Hint: `JOIN rental → inventory → film` + `COUNT`

</div>
</div>
<div class="row mt-4">
<div class="card pop">
<div class="box-h">E3 — Monthly Payments</div>

Total payment amount per bulan, urut kronologis.

Hint: `DATE_TRUNC('month', payment_date)` + `SUM`

</div>
<div class="card pop">
<div class="box-h">E4 — New Customers / Month</div>

First rental month per customer → count new customers by month.

Hint: `MIN(rental_date)` per customer → group lagi

</div>
</div>

---

<div class="eyebrow">// Easy (E5–E8)</div>

## Easy Analytics — Bagian 2

<div class="row mt-4">
<div class="card pop">
<div class="box-h">E5 — Rentals by Category</div>

Total rentals per category, descending.

Hint: `JOIN category → film_category → film → inventory → rental`

</div>
<div class="card pop">
<div class="box-h">E6 — Avg Rental Duration</div>

Rata-rata jam antara `rental_date` dan `return_date` per category.

Hint: `EXTRACT(EPOCH FROM (return_date - rental_date)) / 3600`

</div>
</div>
<div class="row mt-4">
<div class="card pop">
<div class="box-h">E7 — Top 10 Cities</div>

Rentals per kota customer; top 10.

Hint: `JOIN customer → address → city` + `COUNT(rental_id)`

</div>
<div class="card pop">
<div class="box-h">E8 — Active Customers</div>

Distinct customers yang rental di 30 hari terakhir dari data.

Hint: `MAX(rental_date)` sebagai "today", filter `>= today - 30 days`

</div>
</div>

---

<div class="eyebrow">// Medium (M1–M2)</div>

## Cohort & Churn — Bagian 1

<div class="row mt-4">
<div class="card pop" style="flex: 2">
<div class="box-h">M1 — Cohort Retention (months 0–3)</div>

Definisi cohort = bulan first rental customer. Hitung berapa customer dari tiap cohort yang masih aktif di bulan ke-0, 1, 2, 3 setelah cohort mereka.

Output: `cohort_month | m0_active | m1_active | m2_active | m3_active`

Pattern:
```sql
WITH first_rental AS (
  SELECT customer_id, DATE_TRUNC('month', MIN(rental_date)) AS cohort_month
  FROM rental GROUP BY customer_id
),
activity AS (
  SELECT customer_id, DATE_TRUNC('month', rental_date) AS active_month
  FROM rental GROUP BY customer_id, 2
)
SELECT cohort_month,
  COUNT(DISTINCT CASE WHEN months_since = 0 THEN a.customer_id END) AS m0,
  COUNT(DISTINCT CASE WHEN months_since = 1 THEN a.customer_id END) AS m1,
  ...
```
</div>
</div>

---

<div class="eyebrow">// Medium (M2–M3)</div>

## Cohort & Churn — Bagian 2

<div class="row mt-4">
<div class="card pop">
<div class="box-h">M2 — Monthly Churn Rate</div>

**Churned** = aktif bulan lalu, tidak aktif bulan ini.

`churn_rate = churned / active_prev_month`

Hitung untuk 6 bulan terakhir data.

Pattern: CTE monthly active → `LAG` untuk prev month active → filter yang hilang

</div>
<div class="card pop">
<div class="box-h">M3 — Reactivations</div>

Customer yang tidak rental 2 bulan berturut-turut, tapi kembali bulan ini.

Hitung reactivated per bulan.

Pattern: flag "gap 2 bulan" → join ke bulan saat ini

</div>
</div>

---

<div class="eyebrow">// Medium (M4–M6)</div>

## Business Decisions

<div class="row mt-4">
<div class="card pop">
<div class="box-h">M4 — Campaign Impact</div>

Campaign launch: `2005-07-01`. Bandingkan rata-rata monthly rentals per active customer 2 bulan sebelum vs sesudah.

Output: `before_avg | after_avg | delta`

</div>
<div class="card pop">
<div class="box-h">M5 — Inventory Restock Alert</div>

Per film: total copies vs currently rented (`return_date IS NULL`).

Flag film dengan `available_copies < 2`.

</div>
</div>
<div class="mt-4 card pop">
<div class="box-h">M6 — Cross-sell: also-rented</div>

Untuk film 'ACADEMY DINOSAUR', cari 5 film lain yang paling sering dirental oleh **customer yang sama** (co-rental patterns).

Output: `other_film_title | co_rental_count`
</div>

---

<div class="eyebrow">// Hard (H1–H2)</div>

## Advanced Windows — Rolling Metrics

<div class="row mt-4">
<div class="card pop">
<div class="box-h">H1 — 7-day Rolling Rentals by Category</div>

1. Build daily rentals per category
2. `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` → 7-day rolling sum

Output: `rental_day | category | rentals_7d`

```sql
-- Frame pattern:
SUM(rentals) OVER (
  PARTITION BY category
  ORDER BY rental_day
  ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
) AS rentals_7d
```
</div>
<div class="card pop">
<div class="box-h">H2 — 30-day Rolling Spend per Customer</div>

Per customer, per payment row: rolling 30-day total spend.

Gunakan `RANGE` frame dengan interval:

```sql
SUM(amount) OVER (
  PARTITION BY customer_id
  ORDER BY payment_date
  RANGE BETWEEN INTERVAL '30 days' PRECEDING
            AND CURRENT ROW
) AS spend_30d
```
</div>
</div>

---

<div class="eyebrow">// Hard (H3–H4)</div>

## Advanced Windows — Moving Average & Contribution

<div class="row mt-4">
<div class="card pop">
<div class="box-h">H3 — 3-Payment Moving Average</div>

Per customer, ordered by `payment_date`: moving average of `amount` atas 3 payment.

```sql
AVG(amount) OVER (
  PARTITION BY customer_id
  ORDER BY payment_date
  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS movavg_3
```

Output: `customer_id | payment_id | payment_date | amount | movavg_3`

</div>
<div class="card pop">
<div class="box-h">H4 — Monthly Film Contribution Curve</div>

Per bulan: rank film berdasarkan rentals, lalu hitung cumulative share.

```sql
SUM(rentals) OVER (
  PARTITION BY month
  ORDER BY rentals DESC
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS cum_rentals
```

Output: `month | film_id | title | rentals | cum_rentals | cum_share`

</div>
</div>

---

<div class="eyebrow">// Summary</div>

## Day 17 — Full Recap

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Easy ✓</div>

Trend, top-N, monthly aggregation, new customer counting, category breakdown, duration calc, geo analysis, active user count

</div>
<div class="card pop">
<div class="box-h">Medium ✓</div>

Cohort retention matrix, churn rate, reactivations, campaign pre/post, inventory alert, co-rental cross-sell

</div>
<div class="card pop">
<div class="box-h">Hard ✓</div>

7-day rolling sum (`ROWS`), 30-day rolling sum (`RANGE INTERVAL`), 3-payment moving average, cumulative contribution curve

</div>
</div>

---

<div class="eyebrow">// Course Complete</div>

## 5 Hari — Semua Topik

| Day | Topik |
|-----|-------|
| 13 | Intro: RDBMS, ACID, DDL, DML, Types, Views |
| 14 | SELECT, Filter, Aggregate, JOIN, UNION |
| 15 | Subquery, CTE, Ranking, String, Date, Math |
| 16 | Window Functions, OVER, Frame Clauses, LAG/LEAD |
| 17 | Live Coding: Cohort, Churn, Rolling Windows |

---
layout: closing
---

<div class="cover-frame"></div>

<div class="eyebrow">// Day 17 · Course Complete</div>

# <span class="hl">Selesai!</span>

<div class="lead mt-4">From DDL to Window Functions — 5 hari, 1 dataset, analytics nyata.</div>

<div class="mt-8 mono small muted">dvdrental · PostgreSQL · Dibimbing</div>
