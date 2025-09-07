# 🗓️ Day 17: Live Coding on dvdrental

Welcome to the final day! We'll apply CTEs, subqueries, joins, and window functions on dvdrental.

---

### 📝 Session Format

This session is designed to be highly interactive. We will tackle a series of complex, multi-step business problems together. The goal is not just to get the right answer, but to understand the process of breaking down a complex request into manageable SQL steps.

We will focus on:

- **Problem Decomposition**: How to read a business request and translate it into a SQL query plan.
- **Combining Techniques**: Using CTEs to structure logic, window functions for advanced analysis, and joins to bring data together.
- **Query Optimization**: Discussing different approaches and why one might be more efficient than another.

### 🧩 The Problems We'll Solve

1.  **Customer Cohort Analysis**:

    - **Business Goal**: Understand customer retention over time.
    - **SQL Techniques**: This will require grouping by date periods, using conditional aggregation, and likely a `LEFT JOIN` to see activity month over month.

2.  **Inventory Restock Alert**:

    - **Business Goal**: Proactively manage inventory by identifying low-stock items and their recent sales velocity.
    - **SQL Techniques**: We'll combine filtering (`WHERE stock_quantity < 10`), date arithmetic, and window functions to calculate a moving sales average.

3.  **Market Basket Analysis ("Customers Who Bought X Also Bought Y")**:
    - **Business Goal**: Uncover purchasing patterns to power a recommendation engine.
    - **SQL Techniques**: This is a classic analysis that involves `SELF JOIN`s on the `order_items` table, CTEs to isolate customer groups, and aggregation to find the most frequently co-purchased items.

---

### 🎯 Goal for Today

The objective is to build your confidence in tackling real-world data problems from scratch. By the end of this session, you should feel comfortable translating ambiguous business requests into precise, efficient, and readable SQL queries.

Connect with: `psql "postgresql://user:password@localhost:5432/dvdrental"` and open `exercises/live_coding_problems.sql`.
