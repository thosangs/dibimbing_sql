-- Day 14 - UNION vs UNION ALL Examples
-- Dataset: customers, products

-- 1) UNION ALL: keep duplicates
SELECT first_name AS entity_name FROM customers
UNION ALL
SELECT product_name AS entity_name FROM products;

-- 2) UNION: remove duplicates
SELECT first_name AS entity_name FROM customers
UNION
SELECT product_name AS entity_name FROM products;


