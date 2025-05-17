-- performance.sql
-- Initial complex query retrieving bookings with user, property, and payment details,
-- followed by an EXPLAIN ANALYZE to measure performance.

EXPLAIN ANALYZE
SELECT
  b.booking_id,
  b.start_date,
  b.end_date,
  b.total_price,
  u.user_id       AS guest_id,
  u.first_name,
  u.last_name,
  u.email,
  p.property_id,
  p.name          AS property_name,
  p.location,
  pay.payment_id,
  pay.amount      AS payment_amount,
  pay.payment_date
FROM bookings AS b
JOIN users AS u
  ON b.user_id = u.user_id
JOIN properties AS p
  ON b.property_id = p.property_id
LEFT JOIN payments AS pay
  ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;
