# database-script-0x03: JOIN Queries

This directory contains three SQL query examples demonstrating different types of joins in our AirBnB‑style schema. Each query retrieves data by combining rows from related tables to solve common reporting use cases.

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
* Use this when you need combined booking+user information for all confirmed relationships.

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
* Review columns will be `NULL` for properties with no feedback.

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

* **FULL OUTER JOIN** returns:

  * All users (with `NULL` booking columns if they haven’t booked)
  * All bookings (with `NULL` user columns if orphaned)
* Useful for auditing orphaned records or ensuring comprehensive coverage.

---

### How to Run

1. Connect to your PostgreSQL database where the schema is loaded.
2. Copy and paste the desired query into your SQL client (psql, pgAdmin, etc.).
3. Execute and review the result set.

