# 📚 dvdrental SQL Course Project

A comprehensive PostgreSQL project for a 3-day intensive SQL course using the classic dvdrental dataset running in Docker.

---

## 🚀 Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and learning purposes.

### Prerequisites

Make sure you have the following software installed on your system:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- `make` command-line utility

### Installation

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/thosangs/dibimbing_sql.git
    cd dibimbing_sql
    ```

2.  **Create the environment file:**
    This project uses a `.env` file to provide database credentials to Docker Compose.

    Create a file named `.env` in the project root with:

    ```
    POSTGRES_DB=dvdrental
    POSTGRES_USER=user
    POSTGRES_PASSWORD=password
    ```

3.  **Start the database:**
    Use the provided Makefile to start the PostgreSQL container.

    ```sh
    make postgres
    ```

    This starts PostgreSQL 17 on `localhost:5432` and restores the dvdrental sample data automatically on first run.

4.  **Connect to the database:**

    ```sh
    psql "postgresql://user:password@localhost:5432/dvdrental"
    ```

---

## 📂 Project Structure

The project is organized into directories for each day of the course:

- `day_15/`: Advanced SQL using dvdrental
  - `exercises/exercises.sql`: Problems using dvdrental tables
  - `examples/`: Runnable examples (DML, subqueries, CTEs, strings, datetime, numeric)
- `day_16/`: Window functions on dvdrental
  - `exercises/exercises.sql`: Window problems
  - `examples/`: Intro, ranking, navigation, aggregates, window frames
  - `case_study.md`: Business analysis case study (10 analytical questions)
- `day_17/`: Live coding session
  - `exercises/live_coding_problems.sql`: Multi-step problems
- `docker/`: Contains the Docker configuration.

---

## 🗓️ Course Outline

### Day 15: Advanced SQL on dvdrental

- **Core Topics**: DML Part 2, Aggregations, Subqueries, CTEs, Ranking
- **Plus**:
  - String functions (LEFT, RIGHT, SUBSTRING, REPLACE, CONCAT, UPPER, LOWER, LENGTH)
  - Date/Time (NOW, CURRENT_TIMESTAMP, INTERVAL, DATE_TRUNC, EXTRACT)
  - Numeric/Math (ABS, ROUND, MOD, SQRT, FLOOR, CEIL)

### Day 16: Window Functions on dvdrental

- **Core Topics**:
  - Ranking (ROW_NUMBER, RANK, DENSE_RANK, NTILE)
  - Navigation (LEAD, LAG, FIRST_VALUE, LAST_VALUE, NTH_VALUE)
  - Aggregates as windows (AVG, COUNT, MAX, MIN)
  - Window frames (ROWS/RANGE/GROUPS)
- **Includes**: Progressive intro examples and a 10-question analytical case study

### Day 17: Live Coding on dvdrental

- **Core Topics**: Live problem-solving by combining multiple SQL techniques.
- **Goal**: Tackle complex, multi-step business requests in a live coding environment.

---

## 🛠️ Makefile Commands

This project includes a `Makefile` to simplify common tasks:

- `make help`: Shows a list of available commands.
- `make postgres`: Starts the PostgreSQL container in the background.
- `make postgres-down`: Stops the PostgreSQL container.
- `make clean`: Stops and removes the container, network, and data volume.

---

## 📄 License

This project is licensed under the MIT License.
