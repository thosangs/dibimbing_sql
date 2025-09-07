
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
