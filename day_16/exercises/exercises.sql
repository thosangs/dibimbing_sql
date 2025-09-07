
-- Day 16: Window Functions on dvdrental

-- 1) Running total: For each customer, calculate running total of payments over time.
--    Show customer_id, payment_id, payment_date, amount, cumulative_amount.
--    (payment)

-- 2) Moving average: For each customer, 3-payment moving average of amount
--    using ROWS BETWEEN 2 PRECEDING AND CURRENT ROW.

-- 3) Month-over-Month growth: Total payment amount per month and MoM % change using LAG.

-- 4) Rank top 5 films per month by rentals using DENSE_RANK.
--    (rental -> inventory -> film)

-- 5) First rental date per customer via FIRST_VALUE over rental_date.

-- 6) Next rental date per customer via LEAD to compute gaps between rentals.

-- 7) Sliding 7-day window of total payments over payment_date
--    using SUM(...) OVER (ORDER BY payment_date RANGE BETWEEN INTERVAL '6 days' PRECEDING AND CURRENT ROW).

-- 8) Customer spending quartiles: NTILE(4) over total payment per customer.
