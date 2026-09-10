# SAFARI RIDE CTE PRACTICE QUESTIONS

This is a project designed to practice the use of CTEs on a provided dataset, **Safari Ride**.
The DDL required to create the dataset is provided in the 

```
safari_DDL.sql 
```
file.

## Section A

### A1. Busy Drivers
Write a CTE that counts each driver's total trips.

**Requirements:**
- Show only drivers with **5 or more trips**.
- Order results from **most trips to fewest**.

---

### A2. Big Spenders
Write a CTE that calculates each rider's total spend across all their trips.

**Requirements:**
- Show only riders who have spent **more than 3,000** in total.
- Order by **highest total spend first**.

---

### A3. Above-Average Earners
Write a CTE that calculates each driver's average fare per trip.

**Requirements:**
- Show only drivers whose **average fare is above the overall average fare** across **all trips**.
- Order by **highest average fare first**.

> **Hint:** You'll need to determine the overall average fare first—either with a separate query or by hard-coding the value after calculating it.

---

### A4. Popular Payment Methods
Write a CTE that counts trips per `payment_method`.

**Requirements:**
- Show only payment methods used in **more than 12 trips**.
- Order from **most used to least used**.

---

### A5. Top 3 Busiest Drivers
Write a CTE that counts each driver's total trips.

**Requirements:**
- Use `ORDER BY` and `LIMIT` in the outer query.
- Show only the **top 3 busiest drivers**.
- Add a **secondary ORDER BY column** to break ties consistently.

---

### A6. Riders Who Need a Check-In Call
Write a CTE that counts each rider's trips.

**Requirements:**
- Include riders with **zero trips**.
- Show only riders with **fewer than 2 trips**.

> **Hint:** Think about which `JOIN` type preserves rows with no matching trips.

---

# Section B

### B1. Active Driver Leaderboard
Write a CTE that computes each driver's total revenue.

**Requirements:**
- Join the CTE to the `drivers` table.
- Filter to `status = 'Active'`.
- Display:
  - `driver_name`
  - `car_model`
  - `total_revenue`
- Order by **highest revenue first**.

---

### B2. Rating Breakdown
Write a CTE using a `CASE WHEN` statement that labels each trip's `rider_rating` as:

- **Poor** (1–2)
- **Good** (3)
- **Excellent** (4–5)

Then:

- Count the number of trips in each category.
- Order from **most common to least common**.

---

### B3. Premium Rider Fares
Write a CTE that computes each rider's average fare per trip.

**Requirements:**
- Join the CTE to the `riders` table.
- Filter to `membership_tier = 'Premium'`.
- Display:
  - `rider_name`
  - `membership_tier`
  - `avg_fare`
- Order by **highest average fare first**.

---

### B4. The Inactive Driver's History
Write a CTE that counts total trips per driver.

**Requirements:**
- Join to the `drivers` table.
- Filter to `status = 'Inactive'`.
- Display:
  - `driver_name`
  - `total_trips`

> Even inactive drivers may have valuable trip history worth checking.

---

### B5. Early vs. Late Month Trips
Write a CTE using a `CASE WHEN` statement that labels each trip as:

- **Early (1–15)**
- **Late (16–31)**

based on the day of the month in `trip_date`.

Then display:

- Trip count
- Total fare

Order by **highest trip count first**.

> **Hint:** `EXTRACT(DAY FROM trip_date)` returns the day of the month as a number.

---

### B6. Nairobi Riders, Ranked
Write a CTE that computes each rider's total spend.

**Requirements:**
- Join to the `riders` table.
- Filter to `city = 'Nairobi'`.
- Order by **highest total spend first**.

---

# Section C – Challenge

### C1. Underperforming Drivers
Write **two chained CTEs**.

**CTE 1**
- Compute each driver's:
  - `total_trips`
  - Average `rider_rating`

**CTE 2**
- Filter to drivers with:
  - `total_trips >= 4`
  - Average rating **below 3.0**

Finally:

- Join to the `drivers` table.
- Display:
  - `driver_name`
  - `total_trips`
  - `avg_rating`
- Order by **lowest average rating first**.

---

### C2. Above-Average Spenders — Subquery, Then CTE

#### Part 1
Solve using a **correlated subquery**:

> Which riders have spent more than the average total spend across all riders who have taken at least one trip?

#### Part 2
Rewrite the solution using **one or more CTEs**.

For both versions:

- Display:
  - `rider_name`
  - `total_spent`
- Be prepared to explain which approach is easier to maintain.

---

### C3. Riders Who Pay More Per Trip Than Average
Write a CTE that computes each rider's average fare per trip.

Then:

- Calculate the **overall average fare** across all **40 trips**.
- Show riders whose personal average fare exceeds the overall average.
- Order by **highest average fare first**.

---

### C4. Top 3 Riders — Window Function Preview
Write a CTE that ranks riders by `total_spent` using:

```sql
RANK() OVER (ORDER BY total_spent DESC)
```

Then:

- Filter the outer query to `rank <= 3`.

---

### C5. Best Rating Among the Busiest Drivers
Write **two chained CTEs**.

**CTE 1**
- Compute each driver's:
  - `total_trips`
  - `avg_rating`

**CTE 2**
- Keep only drivers whose `total_trips` is **above the average trips per driver**.

Finally:

- Display all qualifying drivers.
- Order by **highest average rating first**.

---

### C6. Challenge — Design Your Own
Create your own business question about SafariRide that requires **at least two steps** to answer.

Example ideas:

- Revenue earned per kilometre driven
- A loyalty score combining:
  - Trip count
  - Average rating

Use **chained CTEs** to solve your question.
