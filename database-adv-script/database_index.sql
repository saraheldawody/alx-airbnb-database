-- Indexes for optimizing high-usage columns in AirBnB schema

-- Users table
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- Bookings table
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings(created_at);

-- Properties table
CREATE INDEX IF NOT EXISTS idx_properties_host_id ON properties(host_id);
CREATE INDEX IF NOT EXISTS idx_properties_location ON properties(location);


-- Measure query performance before and after adding indexes using EXPLAIN ANALYZE.

-- 1. Count bookings for a specific user
-- Before adding indexes:
EXPLAIN ANALYZE
SELECT COUNT(*) AS booking_count
FROM bookings
WHERE user_id = 'b2222222-2222-2222-2222-222222222222';

-- After adding idx_bookings_user_id:
EXPLAIN ANALYZE
SELECT COUNT(*) AS booking_count
FROM bookings
WHERE user_id = 'b2222222-2222-2222-2222-222222222222';

-- 2. Find bookings by user email
-- Before adding indexes:
EXPLAIN ANALYZE
SELECT b.booking_id
FROM bookings b
JOIN users u ON b.user_id = u.user_id
WHERE u.email = 'bob@guest.com';

-- After adding idx_users_email and idx_bookings_user_id:
EXPLAIN ANALYZE
SELECT b.booking_id
FROM bookings b
JOIN users u ON b.user_id = u.user_id
WHERE u.email = 'bob@guest.com';

-- 3. List recent bookings ordered by created_at
-- Before adding idx_bookings_created_at:
EXPLAIN ANALYZE
SELECT booking_id, created_at
FROM bookings
ORDER BY created_at DESC
LIMIT 100;

-- After adding idx_bookings_created_at:
EXPLAIN ANALYZE
SELECT booking_id, created_at
FROM bookings
ORDER BY created_at DESC
LIMIT 100;
