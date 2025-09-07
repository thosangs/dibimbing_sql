# 🗓️ Day 15: Advanced SQL Queries and Data Analysis

Welcome to Day 15! Today, we'll move beyond basic queries and dive into the powerful techniques used for complex data manipulation and analysis in PostgreSQL.

---

### 📝 Core Topics

1.  **DML Part 2 (`INSERT`, `UPDATE`, `DELETE`)**:

    - `INSERT`: Adds new rows to a table.
    - `UPDATE`: Modifies existing rows in a table.
    - `DELETE`: Removes rows from a table. Be careful with `DELETE`! Always use a `WHERE` clause unless you intend to remove all rows.

2.  **Data Analysis with Aggregations**:

    - We'll use aggregate functions like `COUNT()`, `SUM()`, `AVG()`, `MAX()`, and `MIN()` combined with the `GROUP BY` clause to summarize data. This is fundamental for understanding trends and patterns.

3.  **Subqueries (or Inner Queries)**:

    - A subquery is a query nested inside another query. They are incredibly powerful for performing complex filtering and lookups.
    - **Scalar Subquery**: Returns a single value (one row, one column).
    - **Multi-row Subquery**: Can be used with operators like `IN`, `NOT IN`, `ANY`, and `ALL`.

4.  **Common Table Expressions (CTEs)**:

    - CTEs, defined using the `WITH` clause, allow you to create a temporary, named result set that you can reference within a `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement.
    - They dramatically improve the readability and structure of complex queries, breaking them down into logical, easy-to-understand steps.

5.  **Ranking Functions**:
    - Ranking functions assign a rank to each row within a partition of a result set.
    - `ROW_NUMBER()`: Assigns a unique number to each row.
    - `RANK()`: Assigns a rank, but leaves gaps after ties.
    - `DENSE_RANK()`: Assigns a rank without any gaps after ties.

---

### 🎯 Goal for Today

By the end of this session, you will be able to write sophisticated queries to answer complex business questions, manipulate data with precision, and structure your SQL for clarity and maintainability.

Now, let's open `exercises/exercises.sql` and apply these concepts!

---

### 🔌 Connection (dvdrental)

Use this to connect locally:

`psql "postgresql://user:password@localhost:5432/dvdrental"`

---

### ➕ Additional Topics for Day 15 (dvdrental)

- **String Functions**: `LEFT`, `RIGHT`, `SUBSTRING`, `REPLACE`, `CONCAT`, `UPPER`, `LOWER`, `LENGTH`
- **Date/Time Functions**: `NOW`, `CURRENT_TIMESTAMP`, add/subtract `INTERVAL`, `DATE_TRUNC`, `EXTRACT`

- **Numeric/Math Functions**: `ABS`, `ROUND`, `MOD`, `SQRT`, `FLOOR`, `CEIL`

See `day_15/examples/` for runnable examples against dvdrental.
