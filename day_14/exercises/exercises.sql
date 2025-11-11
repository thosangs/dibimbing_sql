-- Day 14 Exercises - Basic and Intermediate SQL Queries
-- Datasets: products, categories, customers, payments (and film for CASE demo)

-- 1) Filtering: products > 100 and stock < 50, order by price desc, top 10
-- TODO: write SELECT with WHERE and ORDER BY, LIMIT 10

-- 2) Filtering: customers in Indonesia OR id = 358, order by customer_id
-- TODO: write SELECT with OR filter

-- 3) Advanced filtering: payments between two dates
-- TODO: write SELECT with BETWEEN '2025-11-01' and '2025-12-01'

-- 4) Advanced filtering: products category_id in 1,5,7
-- TODO: write SELECT with IN (1,5,7)

-- 5) LIKE: customers whose first_name starts with 'D'
-- TODO: write SELECT with LIKE 'D%'

-- 6) Aggregation: total count, average, and sum of payments
-- TODO: write SELECT with COUNT(*), AVG(amount), SUM(amount)

-- 7) Grouping: payments per customer, return columns customer_id, num_payments, total_spent
-- TODO: write GROUP BY query ordered by total_spent desc

-- 8) HAVING: filter customers with 30 or more payments
-- TODO: write same group query with HAVING COUNT(*) >= 30

-- 9) CASE WHEN on film.length to categorize short/medium/long
-- TODO: write SELECT title, length, CASE ... END AS movie_length_category

-- 10) COALESCE on customers.country to show 'Unknown' when null
-- TODO: write SELECT with COALESCE(country, 'Unknown')

-- 11) INNER JOIN: customers and payments with amount and payment_date
-- TODO: write INNER JOIN on customer_id

-- 12) LEFT JOIN: categories with possible products (include categories with no products)
-- TODO: write LEFT JOIN on category_id

-- 13) UNION ALL: list of names combining customers.first_name and products.product_name
-- TODO: write UNION ALL query

-- 14) UNION (distinct): same as above but unique values only
-- TODO: write UNION query


