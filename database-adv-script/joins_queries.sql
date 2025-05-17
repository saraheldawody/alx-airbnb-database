-- Write a query using an INNER JOIN to retrieve all bookings and the respective users who made those bookings.
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

-- Write a query using aLEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews.
SELECT
  p.property_id,
  p.name             AS property_name,
  p.location,
  r.review_id,
  r.user_id          AS reviewer_id,
  r.rating,
  r.comment,
  r.created_at       AS review_date
FROM properties AS p
LEFT JOIN reviews AS r
  ON p.property_id = r.property_id
ORDER BY p.property_id, r.created_at;


-- Write a query using a FULL OUTER JOIN to retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.
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

