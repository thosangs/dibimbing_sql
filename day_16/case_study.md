# Day 16: dvdrental Case Study (Window Functions)

## Scenario

The video rental chain wants insights into customer behavior and film performance using dvdrental.

## Questions

### 1. Identify High-Value Customers

Top 10% of customers by total payments who also rented in at least 3 distinct months in 2005. Return customer_id and total_spend.

### 2. Category Momentum

For each category, compare total rentals in 2005 H1 vs H2. Show category, rentals_h1, rentals_h2, pct_change.

### 3. Star Performers by Year

For each release year, which actor appears in films generating the highest total rentals? Return release_year, actor (first_name || ' ' || last_name), rental_count.

### 4. Lifetime spend trajectory per customer

For every payment a customer makes, show how their total spend has accumulated up to that point in time. Use this to spot customers whose spend is accelerating or flattening.

### 5. Category momentum over the year

By calendar month and category, show rentals accumulated up to each month so far within the same year. Which categories are gathering pace versus plateauing?

### 6. Streaks of consistent engagement

Define a "strike" as renting at least once in each consecutive calendar period (choose week or month) without gaps. Compute every customer's longest strike and list the top 10 customers with the highest strike length. What cadence (weekly vs monthly) reveals more sustained habits?

### 7. Time-to-next-rental

For every customer's rental, compute the number of days until their next one. Surface customers with unusually long gaps as potential churn risks.

### 8. Ordering films inside each category (ties may leave gaps)

Within each category, order films by total rentals using an approach that leaves gaps in positions when ties occur. How do the top positions look under this rule?

### 9. Ordering films without gaps for ties

Within each category, order films by total rentals using an approach that does not leave gaps for ties. Contrast placement with the previous question.

### 10. Sensitivity to window boundaries

Demonstrate how results change when you:

- sum over only the last two events plus the current event for a customer,
- sum over rows that share the same timestamp (to the precision in your data), and
- sum over day-level groups including the previous day group and the current one.
