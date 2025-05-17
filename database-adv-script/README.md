# database-script-0x03: SQL Query Examples

This directory contains SQL query examples demonstrating:

1. Different types of joins in our AirBnB‑style schema (INNER, LEFT, FULL OUTER) to combine related tables for reporting.
2. Use of subqueries to perform aggregations and filters across tables.
3. Use of correlated subqueries to find records based on per-row calculations.

---

## 1. Bookings with Their Users (INNER JOIN)

**Objective:** Fetch all bookings along with the user who made each booking.

```sql
SELECT
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.total_price,
  b.status,
  u.user_id,
  u.first_name,
  u.last_name,
  u.email
FROM bookings AS b
INNER JOIN users AS u
  ON b.user_id = u.user_id
ORDER BY b.created_at;
```

* **INNER JOIN** returns only those bookings that are linked to a valid user.

---

## 2. Properties and Their Reviews (LEFT JOIN)

**Objective:** List all properties and any associated reviews, including properties with no reviews.

```sql
SELECT
  p.property_id,
  p.name         AS property_name,
  p.location,
  r.review_id,
  r.user_id      AS reviewer_id,
  r.rating,
  r.comment,
  r.created_at   AS review_date
FROM properties AS p
LEFT JOIN reviews AS r
  ON p.property_id = r.property_id
ORDER BY p.property_id, r.created_at;
```

* **LEFT JOIN** returns every property regardless of whether it has reviews.

---

## 3. All Users and All Bookings (FULL OUTER JOIN)

**Objective:** Retrieve every user and every booking, even if some users have never booked or some bookings lack a valid user link.

```sql
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  u.role,
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.total_price,
  b.status,
  b.created_at AS booking_created_at
FROM users AS u
FULL OUTER JOIN bookings AS b
  ON u.user_id = b.user_id
ORDER BY u.user_id NULLS FIRST, b.created_at;
```

* **FULL OUTER JOIN** returns all users (with `NULL` booking columns if no bookings) and all bookings (with `NULL` user columns if orphaned).

---

## 4. Properties with High Average Rating (Subquery)

**Objective:** Find all properties where the average rating is greater than 4.0.

```sql
SELECT
  p.property_id,
  p.name,
  p.location,
  avg_reviews.avg_rating
FROM properties AS p
JOIN (
  SELECT
    property_id,
    AVG(rating) AS avg_rating
  FROM reviews
  GROUP BY property_id
) AS avg_reviews
  ON p.property_id = avg_reviews.property_id
WHERE avg_reviews.avg_rating > 4.0
ORDER BY avg_reviews.avg_rating DESC;
```

* The subquery computes the average rating per property, then filters for `avg_rating > 4.0`.

---

## 5. Users with More Than Three Bookings (Correlated Subquery)

**Objective:** Identify users who have made more than 3 bookings.

```sql
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  (
    SELECT COUNT(*)
    FROM bookings AS b
    WHERE b.user_id = u.user_id
  ) AS booking_count
FROM users AS u
WHERE (
    SELECT COUNT(*)
    FROM bookings AS b
    WHERE b.user_id = u.user_id
  ) > 3
ORDER BY booking_count DESC;
```

* The correlated subquery counts bookings per user, and the outer `WHERE` filters those with more than 3.

---

### How to Run

1. Connect to your PostgreSQL database where the schema is loaded.
2. Copy and paste the desired query into your SQL client (psql, pgAdmin, etc.).
3. Execute and review the result set.
