-- Implement range partitioning on bookings by start_date

-- 1. Create a new partitioned parent table
CREATE TABLE bookings_by_date (
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    status booking_status_enum NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (start_date);

-- 2. Create partitions for each quarter (example for 2025)
CREATE TABLE bookings_2025_q1 PARTITION OF bookings_by_date
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');

CREATE TABLE bookings_2025_q2 PARTITION OF bookings_by_date
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');

CREATE TABLE bookings_2025_q3 PARTITION OF bookings_by_date
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');

CREATE TABLE bookings_2025_q4 PARTITION OF bookings_by_date
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');

-- 3. Optionally create a default partition for out-of-range
CREATE TABLE bookings_2025_default PARTITION OF bookings_by_date DEFAULT;

-- 4. Create indexes on each partition (optional, can be inherited)
-- Note: Local indexes needed on each partition
CREATE INDEX idx_bookings_by_date_user_id_q1 ON bookings_2025_q1(user_id);
CREATE INDEX idx_bookings_by_date_user_id_q2 ON bookings_2025_q2(user_id);
CREATE INDEX idx_bookings_by_date_user_id_q3 ON bookings_2025_q3(user_id);
CREATE INDEX idx_bookings_by_date_user_id_q4 ON bookings_2025_q4(user_id);

-- 5. Redirect data from old bookings to new partitions
-- Example: insert existing data
-- INSERT INTO bookings_by_date SELECT booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at FROM bookings;

-- 6. Example query: fetch bookings in a date range
-- EXPLAIN ANALYZE
-- SELECT * FROM bookings_by_date WHERE start_date >= '2025-05-01' AND start_date < '2025-06-01';
