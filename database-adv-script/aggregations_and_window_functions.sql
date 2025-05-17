-- Total Number of Bookings per User
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  COUNT(b.booking_id) AS total_bookings
FROM users AS u
LEFT JOIN bookings AS b
  ON u.user_id = b.user_id
GROUP BY
  u.user_id,
  u.first_name,
  u.last_name
ORDER BY
  total_bookings DESC;


-- Ranking Properties by Number of Bookings
SELECT
  property_id,
  name,
  booking_count,
  RANK() OVER (
    ORDER BY booking_count DESC
  ) AS booking_rank
FROM (
  -- First, compute booking counts per property
  SELECT
    p.property_id,
    p.name,
    COUNT(b.booking_id) AS booking_count
  FROM properties AS p
  LEFT JOIN bookings AS b
    ON p.property_id = b.property_id
  GROUP BY
    p.property_id,
    p.name
) AS prop_counts
ORDER BY
  booking_rank;

