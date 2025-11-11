-- Day 14 - Join Examples
-- Dataset: customers, payments, products, categories

-- 1) INNER JOIN: customers with their payments
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  p.payment_id,
  p.amount,
  p.payment_date
FROM customers c
INNER JOIN payments p
  ON c.customer_id = p.customer_id
ORDER BY c.customer_id, p.payment_date;

-- 2) LEFT JOIN: all categories with optional products
SELECT
  c.category_id,
  c.category_name,
  p.product_id,
  p.product_name
FROM categories c
LEFT JOIN products p
  ON c.category_id = p.category_id
ORDER BY c.category_id, p.product_id NULLS LAST;

-- 3) RIGHT JOIN: all products with optional category
SELECT
  p.product_id,
  p.product_name,
  c.category_id,
  c.category_name
FROM categories c
RIGHT JOIN products p
  ON c.category_id = p.category_id
ORDER BY p.product_id, c.category_id NULLS LAST;

-- 4) FULL OUTER JOIN: all categories and all products (matched when possible)
SELECT
  c.category_id,
  c.category_name,
  p.product_id,
  p.product_name
FROM categories c
FULL OUTER JOIN products p
  ON c.category_id = p.category_id
ORDER BY
  COALESCE(c.category_id, -1),
  COALESCE(p.product_id, -1);

-- 5) CROSS JOIN: Cartesian combination (use carefully)
-- Example: pair first 3 categories with first 3 products
SELECT
  c.category_id,
  c.category_name,
  p.product_id,
  p.product_name
FROM (SELECT * FROM categories ORDER BY category_id LIMIT 3) c
CROSS JOIN (SELECT * FROM products ORDER BY product_id LIMIT 3) p
ORDER BY c.category_id, p.product_id;

-- 6) Multi-join example: payments with customer and category of product (if schema supports)
-- Note: Requires a payments->products relationship; shown as an example pattern
-- SELECT
--   p.payment_id,
--   cu.first_name,
--   cu.last_name,
--   pr.product_name,
--   ca.category_name,
--   p.amount
-- FROM payments p
-- JOIN customers cu ON cu.customer_id = p.customer_id
-- JOIN products pr ON pr.product_id = p.product_id
-- JOIN categories ca ON ca.category_id = pr.category_id;


