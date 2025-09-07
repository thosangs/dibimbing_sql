
-- Day 17: Live Coding on dvdrental

-- Problem 1: Customer Cohort Retention
-- Cohort customers by month of their first rental (from rental.rental_date).
-- For each cohort, compute retention for month 0, 1, 2, 3 after first rental.

-- Problem 2: Film Availability Alert
-- For each film, compute total copies (inventory count) and currently rented copies
-- (rental rows with return_date IS NULL). Flag films with available_copies < 2.

-- Problem 3: "Customers Who Rented X Also Rented Y"
-- For the film titled 'ACADEMY DINOSAUR', find top 5 other films most frequently
-- co-rented by the same customers in the same rentals (same rental_id groups).
