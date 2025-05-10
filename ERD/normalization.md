# Airbnb Database Design Normalization to 3NF

This document reviews the provided Airbnb-style database schema, identifies any normalization issues, and presents an adjusted design in Third Normal Form (3NF). It explains the normalization steps and rationale.

---

## Original Schema

```sql
-- User
User(user_id PK, first_name, last_name, email, password_hash, phone_number, role, created_at)

-- Property
Property(property_id PK, host_id FK → User.user_id, name, description, location, pricepernight, created_at, updated_at)

-- Booking
Booking(booking_id PK, property_id FK → Property.property_id, user_id FK → User.user_id, start_date, end_date, total_price, status, created_at)

-- Payment
Payment(payment_id PK, booking_id FK → Booking.booking_id, amount, payment_date, payment_method)

-- Review
Review(review_id PK, property_id FK → Property.property_id, user_id FK → User.user_id, rating, comment, created_at)

-- Message
Message(message_id PK, sender_id FK → User.user_id, recipient_id FK → User.user_id, message_body, sent_at)
```

Constraints:

* Users: unique email, non-null required fields.
* Booking status and Review rating enumerations/checks.
* Foreign keys linking related entities.

Indexes on email, property\_id, booking\_id, etc.

---

## 1NF (First Normal Form)

1NF requires that each column holds atomic, indivisible values, and each record is unique.

* All attributes in the schema are atomic (e.g., `first_name` and `last_name` instead of a full name).
* Primary keys ensure row uniqueness.

**Conclusion**: The schema conforms to 1NF.

---

## 2NF (Second Normal Form)

2NF requires that the table is in 1NF and that non-key attributes depend on the whole primary key. Since all tables use single-attribute primary keys (UUIDs), there are no partial dependencies.

* No composite primary keys exist.
* All non-key attributes fully depend on their primary key.

**Conclusion**: The schema conforms to 2NF.

---

## 3NF (Third Normal Form)

3NF requires that the table is in 2NF and that all non-key attributes depend only on the primary key (i.e., no transitive dependencies).

### Review for Transitive Dependencies

* **Booking.total\_price**: This value is derived from `Property.pricepernight * (end_date - start_date)`. Storing it introduces redundancy if price per night changes or dates adjust.
* **Property.location**: Currently a single `VARCHAR`. If location data (city, state, country) is used separately, it may be better to decompose, but not strictly required for 3NF unless we need to avoid repeating location details across many properties.
* **Payment.amount**: Matches Booking.total\_price; also derived. However, payments might be partial or include fees, so storing `amount` is acceptable.

#### Action: Remove Derived Attribute

* Move `total_price` out of Booking, since it can be calculated when needed.

### Optional Location Decomposition

If the application requires querying by city, state, country, split `location` into separate fields or a lookup table. This avoids repeating city names as free text.

---

## Revised Schema in 3NF

```sql
-- User
CREATE TABLE "User" (
  user_id UUID PRIMARY KEY,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  email VARCHAR UNIQUE NOT NULL,
  password_hash VARCHAR NOT NULL,
  phone_number VARCHAR,
  role ENUM('guest','host','admin') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Property
CREATE TABLE Property (
  property_id UUID PRIMARY KEY,
  host_id UUID NOT NULL REFERENCES "User"(user_id),
  name VARCHAR NOT NULL,
  description TEXT NOT NULL,
  location VARCHAR NOT NULL,
  price_per_night DECIMAL NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Booking (without total_price)
CREATE TABLE Booking (
  booking_id UUID PRIMARY KEY,
  property_id UUID NOT NULL REFERENCES Property(property_id),
  user_id UUID NOT NULL REFERENCES "User"(user_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status ENUM('pending','confirmed','canceled') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payment
CREATE TABLE Payment (
  payment_id UUID PRIMARY KEY,
  booking_id UUID NOT NULL REFERENCES Booking(booking_id),
  amount DECIMAL NOT NULL,
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  payment_method ENUM('credit_card','paypal','stripe') NOT NULL
);

-- Review
CREATE TABLE Review (
  review_id UUID PRIMARY KEY,
  property_id UUID NOT NULL REFERENCES Property(property_id),
  user_id UUID NOT NULL REFERENCES "User"(user_id),
  rating INTEGER NOT NULL CHECK (rating >=1 AND rating <=5),
  comment TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Message
CREATE TABLE Message (
  message_id UUID PRIMARY KEY,
  sender_id UUID NOT NULL REFERENCES "User"(user_id),
  recipient_id UUID NOT NULL REFERENCES "User"(user_id),
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Notes on Revised Design

1. **Booking.total\_price removed**: Calculate `total_price` as:

   ```sql
   SELECT price_per_night * (end_date - start_date) AS total_price
   FROM Booking b
   JOIN Property p ON b.property_id = p.property_id
   WHERE b.booking_id = :booking_id;
   ```
2. **Location** remains atomic; decompose only if needed for reporting.
3. All tables now ensure non-key attributes depend solely on primary keys, achieving 3NF.

---

## Summary of Normalization Steps

| Normal Form | Action Taken                                 | Result                |
| ----------- | -------------------------------------------- | --------------------- |
| 1NF         | Verified atomic attributes and unique rows   | Compliant             |
| 2NF         | Checked full dependency on single-column PKs | Compliant             |
| 3NF         | Removed derived attribute (`total_price`)    | Eliminated redundancy |

This design is now normalized to 3NF, eliminating potential anomalies and ensuring data integrity.
