# 🗓️ Day 16: Window Functions on dvdrental

All exercises use dvdrental via:

`psql "postgresql://user:password@localhost:5432/dvdrental"`

---

### 📝 Core Topics

1.  **Window Functions**:
    Window functions perform a calculation across a set of table rows that are somehow related to the current row. This is comparable to the type of calculation that can be done with an aggregate function. But unlike regular aggregate functions, use of a window function does not cause rows to become grouped into a single output row.

    The generic syntax is:
    `FUNCTION_NAME() OVER (PARTITION BY ... ORDER BY ... FRAME_CLAUSE)`

    - `PARTITION BY`: Divides the rows into partitions (groups). The function is applied independently to each partition.
    - `ORDER BY`: Orders rows within each partition.
    - `FRAME_CLAUSE` (`ROWS` or `RANGE`): Specifies the subset of rows (the "frame") within the current partition to be used for the calculation. For example:
      - `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` (for a running total).
      - `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW` (for a 3-period moving average).

    **Types of Window Functions we will cover (with examples in `examples/`):**

    - **Ranking**: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()`
    - **Navigation**: `LEAD()`, `LAG()`, `FIRST_VALUE()`, `LAST_VALUE()`, `NTH_VALUE()`
    - **Aggregates as Windows**: `AVG()`, `COUNT()`, `MAX()`, `MIN()`

2.  **NoSQL (Conceptual)**:

    - While our focus is PostgreSQL (a relational/SQL database), it's crucial to understand the landscape of data storage. NoSQL databases are an alternative.
    - **Key Characteristics**:
      - **Flexible Schema**: NoSQL databases often don't require a predefined schema, making them ideal for unstructured or semi-structured data (like user reviews, logs, etc.).
      - **Scalability**: Typically designed to scale out horizontally across many servers.
      - **Variety of Models**: Document (MongoDB), Key-Value (Redis), Column-Family (Cassandra), and Graph (Neo4j).
    - We'll discuss why a NoSQL database like MongoDB might be a better fit for storing a feature like book reviews.

3.  **Business Analysis Case Study (dvdrental)**:
    - Apply window functions to dvdrental problems in `case_study.md`.

---

### 🎯 Goal for Today

Master window functions on dvdrental for running totals, moving averages, and MoM growth.

Let's get started with `exercises/exercises.sql`!
