-- Day 15 - JOINs (INNER, LEFT, RIGHT, FULL, CROSS) with realistic temp tables
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"
--
-- Domain: simple e-commerce data model

-- Customers
CREATE TEMP TABLE customers (
  customer_id int PRIMARY KEY,
  full_name   text,
  email       text,
  city        text
);
INSERT INTO customers VALUES
  (1, 'Alice Park', 'alice@example.com', 'San Francisco'),
  (2, 'Bob Kim',   'bob@example.com',   'Los Angeles'),
  (3, 'Carol Lee', 'carol@example.com', 'Seattle'),
  (4, 'Dan Cho',   'dan@example.com',   'Austin');

-- Orders (including one order with an unknown customer_id to illustrate RIGHT/FULL joins)
CREATE TEMP TABLE orders (
  order_id    int PRIMARY KEY,
  customer_id int,
  order_date  date,
  status      text
);
INSERT INTO orders VALUES
  (101, 1, DATE '2025-10-01', 'paid'),
  (102, 1, DATE '2025-10-03', 'refunded'),
  (103, 2, DATE '2025-10-05', 'paid'),
  (104, 5, DATE '2025-10-06', 'paid'); -- unknown customer_id to demo RIGHT/FULL

-- Products
CREATE TEMP TABLE products (
  product_id   int PRIMARY KEY,
  sku          text,
  product_name text,
  price        numeric(10,2)
);
INSERT INTO products VALUES
  (11, 'TS-RED-S', 'T-Shirt Red Small', 19.99),
  (12, 'TS-RED-M', 'T-Shirt Red Medium', 19.99),
  (21, 'MUG-BLK',  'Black Mug', 9.50);

-- Order line items (not every order has items; not every product is ordered)
CREATE TEMP TABLE order_items (
  order_id   int,
  product_id int,
  quantity   int
);
INSERT INTO order_items VALUES
  (101, 11, 2),
  (101, 21, 1),
  (103, 21, 3);

-- Lookup tables for CROSS JOIN example
CREATE TEMP TABLE sizes (size text);
INSERT INTO sizes VALUES ('S'), ('M'), ('L');

CREATE TEMP TABLE colors (color text);
INSERT INTO colors VALUES ('Red'), ('Black');

-- 1) INNER JOIN: customers with at least one order
SELECT c.customer_id, c.full_name, o.order_id, o.status
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_id;

-- 2) LEFT JOIN: all customers, with orders if any (nulls when no matching order)
SELECT c.customer_id, c.full_name, o.order_id, o.status
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_id;

-- 3) RIGHT JOIN: all orders, with their customers if any (shows unknown customer_id 5)
SELECT c.customer_id, c.full_name, o.order_id, o.status
FROM customers c
RIGHT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- 4) FULL OUTER JOIN: include unmatched rows on both sides
SELECT
  c.customer_id AS customer_id,
  c.full_name   AS customer_name,
  o.order_id    AS order_id,
  o.status      AS order_status
FROM customers c
FULL OUTER JOIN orders o ON o.customer_id = c.customer_id
ORDER BY COALESCE(c.customer_id, o.customer_id), o.order_id;

-- 5) Multi-table JOIN: order lines with product details and customer
SELECT
  o.order_id,
  c.full_name,
  p.sku,
  p.product_name,
  oi.quantity,
  ROUND(oi.quantity * p.price, 2) AS line_total
FROM orders o
JOIN customers c   ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p     ON p.product_id = oi.product_id
ORDER BY o.order_id, p.product_id;

-- 6) CROSS JOIN: generate all color x size product variants
SELECT c.color, s.size
FROM colors c
CROSS JOIN sizes s
ORDER BY c.color, s.size;

-- Note: TEMP tables auto-drop at session end.


