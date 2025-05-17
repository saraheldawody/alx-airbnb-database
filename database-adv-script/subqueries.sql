-- 1. Properties with average rating > 4.0
SELECT
  p.property_id,
  p.name,
  p.location,
  avg_reviews.avg_rating
FROM properties AS p
JOIN (
  -- compute average rating per property
  SELECT
    property_id,
    AVG(rating) AS avg_rating
  FROM reviews
  GROUP BY property_id
) AS avg_reviews
  ON p.property_id = avg_reviews.property_id
WHERE avg_reviews.avg_rating > 4.0
ORDER BY avg_reviews.avg_rating DESC;


-- 2. Users who have made more than 3 bookings
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

