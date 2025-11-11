-- Day 14 - Filtering and Advanced Filtering Examples
-- Dataset: products, categories, customers, payments (per logic.md)

-- 1) Filtering with AND, ORDER BY, LIMIT
SELECT
  product_name,
  price,
  category_id
FROM products
WHERE price > 100
  AND stock < 50
ORDER BY price DESC
LIMIT 20;

-- 2) OR condition on customers
SELECT
  customer_id,
  first_name,
  last_name,
  country
FROM customers
WHERE country = 'Indonesia'
   OR customer_id = 358
ORDER BY customer_id;

-- 3) BETWEEN on payments by date range
SELECT
  payment_id,
  customer_id,
  amount,
  payment_date
FROM payments
WHERE payment_date BETWEEN '2025-11-01' AND '2025-12-01'
ORDER BY payment_date;

-- 4) IN for product categories
SELECT
  product_id,
  product_name,
  category_id
FROM products
WHERE category_id IN (1, 5, 7)
ORDER BY product_id;

-- 5) LIKE on customer first name, starts with D
SELECT
  first_name,
  last_name
FROM customers
WHERE first_name LIKE 'D%';


