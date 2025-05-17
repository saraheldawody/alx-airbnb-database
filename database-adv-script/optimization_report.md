# Query Optimization Report

This report analyzes the performance of a complex query that retrieves bookings, user details, property details, and payment details. It identifies inefficiencies and presents a refactored version for better performance.

---

## 1. Initial Query Performance

**Query:** See `performance.sql` for the full SQL and `EXPLAIN ANALYZE` output.

**EXPLAIN ANALYZE Summary (before indexes):**

```
Seq Scan on bookings b  (cost=0.00..50000.00 rows=5000 width=256)
  -> Nested Loop  (actual rows=500 loops=1)
     -> Seq Scan on users u  (cost=0.00..1000.00)  
     -> Seq Scan on properties p (cost=0.00..1500.00)
     -> Seq Scan on payments pay (cost=0.00..2000.00)
Actual Total Time: ~120 ms
```

*Note: Times and costs are illustrative.*

### Identified Bottlenecks

1. **Full Table Scans** on `bookings`, `users`, `properties`, and `payments`.
2. **Nested Loop Joins** without index use, causing repeated scans.
3. **Ordering** by `b.created_at` triggers a full sort.
4. **LEFT JOIN payments** loads unnecessary rows when payments are absent.

---

## 2. Refactored Query

### Optimization Strategies

* **Ensure indexes** on join/filter columns: `bookings.user_id`, `bookings.property_id`, `payments.booking_id`, `bookings.created_at`.
* **Pre-aggregate payments** to reduce LEFT JOIN complexity.
* **Select only needed columns** to reduce data transfer.

### Refactored SQL

```sql
EXPLAIN ANALYZE
SELECT
  b.booking_id,
  b.start_date,
  b.end_date,
  b.total_price,
  u.user_id       AS guest_id,
  u.first_name,
  u.last_name,
  p.property_id,
  p.name          AS property_name,
  COALESCE(pay_summary.total_paid, 0) AS total_paid
FROM bookings AS b
JOIN users AS u
  ON b.user_id = u.user_id
JOIN properties AS p
  ON b.property_id = p.property_id
LEFT JOIN (
  SELECT booking_id, SUM(amount) AS total_paid
  FROM payments
  GROUP BY booking_id
) AS pay_summary
  ON b.booking_id = pay_summary.booking_id
ORDER BY b.created_at DESC;
```

**Changes Made:**

* Aggregated `payments` in a subquery (`pay_summary`), reducing rows in the join.
* Removed individual `payment_id` and `payment_date` columns since only total is needed.

---

## 3. Post-Optimization Performance

**EXPLAIN ANALYZE Summary (with indexes and refactor):**

```
Index Scan on bookings b using idx_bookings_created_at  (cost=0.00..1200.00 rows=5000 width=128)
  -> Nested Loop  (actual rows=500 loops=1)
     -> Index Scan on users u using pk_users                           
     -> Index Scan on properties p using pk_properties
     -> Hash Join to pay_summary                                   
Actual Total Time: ~25 ms
```

*Note: Times and plans are illustrative.*

### Results

* **70%–80% reduction** in execution time.
* Shift from **sequential scans** to **index scans** and a **hash join** for aggregated payments.

---

## 4. Recommendations

* **Maintain indexes** on critical columns and monitor their usage.
* **Review query patterns** periodically and refactor as data grows.
* Consider **partitioning** large tables (e.g., `bookings`) by date for further improvements.
