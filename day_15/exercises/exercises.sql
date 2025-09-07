
-- Day 15: Advanced SQL on dvdrental

-- DML Part 2 + Aggregations

-- 1) Insert a new category named 'Tutorials'. Then associate any 3 films by title to it in
--    table film_category. Finally, delete those 3 associations and the 'Tutorials' category.

-- 2) Increase rental_rate by 10% for all films in the 'Action' category.
--    (Hint: UPDATE film f SET rental_rate = rental_rate * 1.10 FROM film_category fc JOIN category c USING(category_id)
--           WHERE f.film_id = fc.film_id AND c.name = 'Action')

-- 3) For each category, count total rentals. Which category has the most rentals?
--    (Hint: rental -> inventory -> film -> film_category -> category)


-- Subqueries

-- 4) List customers who rented the film titled 'ACADEMY DINOSAUR'. Use a subquery in the WHERE clause.

-- 5) Find films featuring actors who appear in more than 10 films. Use a subquery with GROUP BY/HAVING on film_actor.


-- CTEs & Ranking

-- 6) Using a CTE on payment, compute total spend per customer and list the top 10 spenders.

-- 7) Rank films by number of rentals within each category (most rented first).

-- 8) Using ROW_NUMBER(), find each customer's second most recent rental (by rental_date).

-- Numeric/Math Functions

-- 9) For each customer, compute the average payment and ROUND it to 2 decimals.
--    List any 10 customers with their rounded average.

-- 10) For films, show rental_rate along with FLOOR and CEIL values.
--     List any 10 films by film_id.

-- 11) Show the ABS difference between each payment amount and the overall average payment.
--     Return the top 10 largest differences with payment_id and amount.

-- 12) Use MOD to bucket rentals by rental_id % 5 and count rentals per bucket.

-- 13) Compute SQRT of film length (minutes) for films with non-null length; list any 10.
