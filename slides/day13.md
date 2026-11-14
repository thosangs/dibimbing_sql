---
theme: default
title: "Day 13 · Intro to Databases"
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

<div class="eyebrow">// Dibimbing SQL · Day 13</div>

# Intro to <span class="hl">Databases</span>

<div class="lead">Fondasi yang kamu pakai seterusnya.</div>

<div class="row mt-8" style="max-width: 680px">
  <div class="card pop"><div class="box-h">Session</div><b>Day 13 of 17</b></div>
  <div class="card pop"><div class="box-h">Dataset</div><b>dvdrental (PostgreSQL)</b></div>
  <div class="card pop"><div class="box-h">Level</div><b>Foundational</b></div>
</div>

---
layout: default
---

<div class="eyebrow">// Agenda</div>

## Hari ini kita cover

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Konsep</div>

- Apa itu database & DBMS
- Relational core: table, row, column, PK/FK
- Normalisasi (1NF–3NF)
- ACID transactions
- SQL vs NoSQL

</div>
<div class="card pop">
<div class="box-h">Praktik (SQL)</div>

- DDL: `CREATE`, `ALTER`, `DROP`, `INDEX`
- DML: `INSERT`, `UPDATE`, `DELETE`, `SELECT`
- Column types: char, numeric, date, interval
- Materialization: CTE, view, materialized view

</div>
</div>

---

<div class="eyebrow">// What is a Database</div>

## Database & DBMS

**Database** — koleksi data terstruktur yang mendukung penyimpanan, pencarian, dan manajemen yang efisien.

**DBMS** — software yang mengelola database, menyediakan transaksi, durabilitas, concurrency.

<div class="row mt-6">
<div class="card pop">
<div class="box-h">RDBMS</div>

PostgreSQL · MySQL · SQL Server · Oracle

Skema terdefinisi, relasi antar tabel, SQL sebagai query language.

</div>
<div class="card">
<div class="box-h">NoSQL</div>

**Key-Value** Redis &nbsp;·&nbsp; **Document** MongoDB

**Columnar** Cassandra &nbsp;·&nbsp; **Graph** Neo4j

Fleksibel, scale-out, biasanya eventual consistency.

</div>
</div>

---

<div class="eyebrow">// Relational Core</div>

## Tabel, Baris, Kolom

```
┌─────────────────────────────────────────────────┐
│  TABLE: customer                                │
│  ┌────────────┬──────────────┬───────────────┐  │
│  │ customer_id│ first_name   │ last_name     │  │  ← kolom (attribute)
│  │ (PK, int)  │ (varchar)    │ (varchar)     │  │
│  ├────────────┼──────────────┼───────────────┤  │
│  │     1      │ MARY         │ SMITH         │  │  ← baris (tuple)
│  │     2      │ PATRICIA     │ JOHNSON       │  │
│  └────────────┴──────────────┴───────────────┘  │
└─────────────────────────────────────────────────┘
```

- **Primary Key (PK)** — identitas unik tiap baris
- **Foreign Key (FK)** — kolom yang merujuk PK di tabel lain
- **Relation** — hubungan antar tabel lewat PK/FK

---

<div class="eyebrow">// ACID</div>

## ACID Transactions

<div class="row mt-4">
<div class="card pop">
<div class="box-h">A — Atomicity</div>
Semua atau tidak sama sekali. Kalau satu langkah gagal, seluruh transaksi di-rollback.
</div>
<div class="card pop">
<div class="box-h">C — Consistency</div>
Transisi dari satu state valid ke state valid lain. Constraints selalu terpenuhi.
</div>
</div>
<div class="row mt-4">
<div class="card pop">
<div class="box-h">I — Isolation</div>
Transaksi concurrent tidak saling ganggu. Masing-masing seolah berjalan sendiri.
</div>
<div class="card pop">
<div class="box-h">D — Durability</div>
Setelah COMMIT, data persisten meski server crash. Data ditulis ke disk (WAL).
</div>
</div>

---

<div class="eyebrow">// SQL vs NoSQL</div>

## Kapan pakai mana?

| | SQL (RDBMS) | NoSQL |
|---|---|---|
| Skema | Rigid, defined upfront | Fleksibel, schema-on-read |
| Consistency | Strong (ACID) | Often eventual |
| Joins | Native, powerful | Expensive atau tidak ada |
| Scale | Vertical (+ read replicas) | Horizontal scale-out |
| Use case | Transaksi, reporting, analytics | Logs, feeds, unstructured data |

> Modern stacks sering kombinasi keduanya — Postgres untuk transaksional, Redis untuk cache, Mongo untuk events.

---

<div class="eyebrow">// DDL</div>

## Data Definition Language

DDL mendefinisikan **struktur** database. Perintah utama:

`CREATE` · `ALTER` · `DROP` · `TRUNCATE` · `CREATE INDEX`

```sql
-- Buat tabel dengan PK dan FK ke customer
CREATE TABLE customer_note (
    customer_id integer NOT NULL REFERENCES customer(customer_id),
    note        text    NOT NULL,
    created_at  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (customer_id, created_at)
);

-- Tambah kolom baru
ALTER TABLE film ADD COLUMN IF NOT EXISTS imdb_url text;

-- Partial index: hanya rental yang belum dikembalikan
CREATE INDEX IF NOT EXISTS idx_rental_outstanding
    ON rental (rental_date)
    WHERE return_date IS NULL;
```

DDL di PostgreSQL **auto-commit** — tidak bisa di-rollback kecuali dalam explicit transaction block.

---

<div class="eyebrow">// DDL — Object Lifecycle</div>

## CREATE → RENAME → DROP

```sql
-- Siklus lengkap: buat, rename, hapus
CREATE TABLE training_scratch (
    id    serial PRIMARY KEY,
    label text
);

ALTER TABLE training_scratch RENAME TO training_scratch_v2;

DROP TABLE IF EXISTS training_scratch_v2;

-- TRUNCATE: hapus semua baris tapi pertahankan struktur
-- Jauh lebih cepat dari DELETE tanpa WHERE
TRUNCATE TABLE customer_note;
```

`DROP` menghapus objek permanen. `TRUNCATE` hanya mengosongkan data.

---

<div class="eyebrow">// DML</div>

## Data Manipulation Language

DML memanipulasi **data** (bukan struktur). Perintah utama:

`SELECT` · `INSERT` · `UPDATE` · `DELETE` · `UPSERT`

```sql
BEGIN;

-- INSERT dengan RETURNING
INSERT INTO actor (first_name, last_name)
VALUES ('TRAIN', 'DEMO')
RETURNING actor_id, first_name, last_name;

-- UPDATE dengan RETURNING
UPDATE film
SET rental_rate = rental_rate + 0.50
WHERE rating IN ('G', 'PG')
RETURNING film_id, title, rental_rate;

-- UPSERT (ON CONFLICT)
INSERT INTO actor (actor_id, first_name, last_name)
VALUES (99999, 'UPSERT', 'DEMO')
ON CONFLICT (actor_id) DO UPDATE
SET first_name = EXCLUDED.first_name,
    last_update = now();

ROLLBACK; -- demo aman, tidak mengubah data
```

---

<div class="eyebrow">// Column Types</div>

## Tipe Data Utama di PostgreSQL

<div class="row mt-2">
<div class="card pop">
<div class="box-h">String</div>

`CHAR(n)` — fixed-length, space-padded

`VARCHAR(n)` — variable, max n chars

`TEXT` — unlimited length

</div>
<div class="card pop">
<div class="box-h">Numeric</div>

`INTEGER` — 32-bit int (-2B to 2B)

`BIGINT` — 64-bit int

`NUMERIC(p,s)` — exact decimal

</div>
<div class="card pop">
<div class="box-h">Temporal</div>

`DATE` — date only

`TIMESTAMPTZ` — timestamp + timezone

`INTERVAL` — duration ('3 days', '2 hours')

</div>
</div>

---

<div class="eyebrow">// Column Types — Code</div>

## Type Demo

```sql
CREATE TABLE typing_demo (
    id          serial PRIMARY KEY,
    code        char(5),              -- fixed-length, space-padded
    name        varchar(50),          -- variable-length with limit
    description text,                 -- unlimited
    active      boolean DEFAULT true,
    qty         integer,
    price       numeric(10,2),        -- fixed precision
    created_on  date DEFAULT current_date,
    updated_at  timestamptz DEFAULT now(),
    duration    interval
);

-- Casting dan operasi tipe
SELECT
    id,
    rtrim(code)                      AS code_trimmed,  -- hilangkan padding CHAR
    qty::bigint * 1000               AS qty_milliunits,
    (price * qty)::numeric(12,2)     AS extended_price,
    created_on + duration            AS created_plus_duration,
    active::int                      AS active_as_int   -- true→1, false→0
FROM typing_demo;
```

---

<div class="eyebrow">// Materialization</div>

## 5 Strategi Materialisasi

```
CTE            → query inline, bukan tabel fisik (biasanya)
Derived Table  → subquery di FROM clause
Temp Table     → tabel sementara, session-scoped, auto-drop
Unlogged Table → tabel permanen tapi tidak WAL-logged (faster writes)
View           → virtual, query dieksekusi tiap akses
Materialized View → snapshot fisik, harus di-REFRESH manual
```

Pilih berdasarkan: frekuensi akses, kebutuhan refresh, ukuran data.

---

<div class="eyebrow">// Materialization — Code</div>

## CTE, View, Materialized View

<div class="code-sm">

```sql
-- CTE: inline, tidak disimpan
WITH recent_rentals AS (
    SELECT customer_id, rental_date
    FROM rental WHERE rental_date >= now() - interval '60 days'
)
SELECT c.first_name, COUNT(rr.rental_id) AS rentals_60d
FROM customer c LEFT JOIN recent_rentals rr USING (customer_id)
GROUP BY c.customer_id ORDER BY rentals_60d DESC LIMIT 10;

-- VIEW: virtual, selalu fresh
CREATE VIEW vw_film_rental_counts AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS num_rentals
FROM film f
LEFT JOIN inventory i USING (film_id)
LEFT JOIN rental r USING (inventory_id)
GROUP BY f.film_id;

-- MATERIALIZED VIEW: fisik, perlu REFRESH
CREATE MATERIALIZED VIEW mv_top_films AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS num_rentals
FROM film f JOIN inventory i USING (film_id) JOIN rental r USING (inventory_id)
GROUP BY f.film_id ORDER BY num_rentals DESC
WITH NO DATA;

REFRESH MATERIALIZED VIEW mv_top_films;
```

</div>

---

<div class="eyebrow">// Summary</div>

## Day 13 — Recap

<div class="row mt-4">
<div class="card pop">
<div class="box-h">Konsep ✓</div>

- Database = organized data + DBMS guarantees
- RDBMS: tabel, PK/FK, JOIN
- ACID: Atomicity, Consistency, Isolation, Durability
- SQL = strong consistency; NoSQL = flexible scale

</div>
<div class="card pop">
<div class="box-h">SQL ✓</div>

- DDL: CREATE / ALTER / DROP / INDEX
- DML: INSERT / UPDATE / DELETE + UPSERT
- Types: char, numeric, bool, date, timestamptz, interval
- Materialization: CTE → View → Materialized View

</div>
</div>

<div class="mt-6 card flat">
<div class="box-h">Next → Day 14</div>
Filtering, Aggregation, JOIN, CASE WHEN, UNION
</div>

---
layout: closing
---

<div class="cover-frame"></div>

<div class="eyebrow">// Day 13 · Done</div>

# Lanjut ke <span class="hl">Day 14</span>

<div class="lead mt-4">Basic & Intermediate SQL Queries</div>
