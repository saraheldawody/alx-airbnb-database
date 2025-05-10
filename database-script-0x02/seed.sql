-- Sample data for alx-airbnb-database

-- 1. Users
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  ('a1111111-1111-1111-1111-111111111111', 'Alice', 'Smith', 'alice@host.com', 'hash1', '01000000001', 'host'),
  ('b2222222-2222-2222-2222-222222222222', 'Bob', 'Jones', 'bob@guest.com', 'hash2', '01000000002', 'guest'),
  ('c3333333-3333-3333-3333-333333333333', 'Carol', 'White', 'carol@guest.com', 'hash3', NULL, 'guest'),
  ('d4444444-4444-4444-4444-444444444444', 'Dave', 'Brown', 'dave@host.com', 'hash4', '01000000004', 'host'),
  ('e5555555-5555-5555-5555-555555555555', 'Eve', 'Black', 'eve@admin.com', 'hash5', NULL, 'admin');

-- 2. Properties
INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
VALUES
  ('p1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Cozy Downtown Loft', 'A modern loft in the city center, close to all attractions.', 'Cairo, Egypt', 120.00),
  ('p2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'Quiet Suburban Home', 'Spacious 3-bedroom house with garden.', 'Giza, Egypt', 85.50),
  ('p3333333-3333-3333-3333-333333333333', 'd4444444-4444-4444-4444-444444444444', 'Beachside Bungalow', 'Charming bungalow by the Red Sea.', 'Hurghada, Egypt', 200.00);

-- 3. Bookings
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
  ('bk111111-1111-1111-1111-111111111111', 'p1111111-1111-1111-1111-111111111111', 'b2222222-2222-2222-2222-222222222222', '2025-06-01', '2025-06-05', 480.00, 'pending'),
  ('bk222222-2222-2222-2222-222222222222', 'p2222222-2222-2222-2222-222222222222', 'c3333333-3333-3333-3333-333333333333', '2025-05-15', '2025-05-20', 427.50, 'confirmed'),
  ('bk333333-3333-3333-3333-333333333333', 'p3333333-3333-3333-3333-333333333333', 'b2222222-2222-2222-2222-222222222222', '2025-07-10', '2025-07-12', 400.00, 'canceled');

-- 4. Payments
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
VALUES
  ('pay111111-1111-1111-1111-111111111111', 'bk222222-2222-2222-2222-222222222222', 427.50, 'credit_card'),
  ('pay222222-2222-2222-2222-222222222222', 'bk333333-3333-3333-3333-333333333333', 400.00, 'paypal');

-- 5. Reviews
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
VALUES
  ('r1111111-1111-1111-1111-111111111111', 'p2222222-2222-2222-2222-222222222222', 'c3333333-3333-3333-3333-333333333333', 5, 'Lovely home, very clean and comfortable.'),
  ('r2222222-2222-2222-2222-222222222222', 'p3333333-3333-3333-3333-333333333333', 'b2222222-2222-2222-2222-222222222222', 4, 'Great location but a bit noisy at night.');

-- 6. Messages
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
VALUES
  ('m1111111-1111-1111-1111-111111111111', 'b2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'Hi Alice, is the loft available early check-in?'),
  ('m2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'b2222222-2222-2222-2222-222222222222', 'Yes Bob, early check-in at 12:00 is possible.'),
  ('m3333333-3333-3333-3333-333333333333', 'c3333333-3333-3333-3333-333333333333', 'd4444444-4444-4444-4444-444444444444', 'Hello Dave, can I bring my pet?');
