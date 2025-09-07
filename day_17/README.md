# 🗓️ Day 17: Live Coding on dvdrental

Welcome to the final day! In the next 3 hours, we will solve a continuous, story-driven set of analytics and business problems using dvdrental. We'll start with easy exploratory questions, move to medium business decisions (including cohort and churn), and finish with hard windowing tasks using custom frames.

---

### 🎭 Story: The New Release Push

The dvdrental chain has launched a “New Release Push” campaign. Leadership wants to understand customer growth, engagement, churn, and inventory needs, then evaluate campaign performance and forecast demand. You are the analyst building insights step by step.

---

### 🧭 Session Structure

- **Easy (8)**: Exploratory analytics to get the lay of the land
- **Medium (6)**: Business decisions, including cohorts and churn analysis
- **Hard (4)**: Advanced windowing with custom frames for rolling metrics and contribution curves

All problems are in `day_17/exercises/live_coding_problems.sql` and can be solved against the dvdrental database.

---

### 🛠️ Techniques We'll Use

- Joins, filters, grouping, conditional aggregation
- Subqueries and CTEs for structure and readability
- Window functions with custom frames (ROWS/RANGE) for rolling and cumulative analytics

---

### 📡 How to Run

Connect with:

`psql "postgresql://user:password@localhost:5432/dvdrental"`

Open:

`day_17/exercises/live_coding_problems.sql`

Work through Easy → Medium → Hard in order to follow the story.
