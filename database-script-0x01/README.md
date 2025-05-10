# alx-airbnb-database: database-script-0x01

This repository contains the SQL schema definition for an AirBnB‑style application, designed as part of the ALX Holberton School curriculum. It defines all core entities (users, properties, bookings, payments, reviews, messages), their relationships, constraints, and performance indexes.

## Contents

* **schema.sql**: PostgreSQL DDL script that:

  * Enables UUID generation
  * Creates necessary ENUM types
  * Defines tables with appropriate data types, primary keys, foreign keys, and check constraints
  * Adds indexes for performance
  * Implements trigger for automatic `updated_at` maintenance

* **README.md**: This document.

## Prerequisites

* PostgreSQL 12+ with superuser privileges
* `uuid-ossp` extension available
* psql (or any SQL client) to run the DDL script

## Setting Up

1. **Clone the repo**

   ```bash
   git clone https://github.com/your-username/alx-airbnb-database.git
   cd alx-airbnb-database/database-script-0x01
   ```

2. **Connect to PostgreSQL**

   ```bash
   psql -U <your_db_user> -d <your_database>
   ```

3. **Run the schema script**

   ```sql
   \i schema.sql
   ```

   This will create all tables, types, constraints, indexes, and triggers.

## Schema Overview

| Table        | Description                              |
| ------------ | ---------------------------------------- |
| `users`      | Registered users (guests, hosts, admins) |
| `properties` | Listings owned by hosts                  |
| `bookings`   | Reservations made by guests              |
| `payments`   | Payments for bookings                    |
| `reviews`    | Guest reviews of properties              |
| `messages`   | In-app messaging between users           |

### Key Features

* **UUID PKs**: All primary keys use `UUID` for uniqueness across distributed systems.
* **ENUM Types**: Roles, booking statuses, and payment methods enforced at the database level.
* **Timestamps**: Automatic creation timestamps; `properties.updated_at` auto-updates on change.
* **Referential Integrity**: Cascading deletes to keep data consistent.
* **Indexes**: Added on foreign keys and frequently queried columns for performance.

## Next Steps

* Write migration scripts (e.g., using Flyway or Django migrations)
* Seed initial data for testing
* Integrate with application code (ORM models)
* Add advanced features: availability calendars, location indexing (PostGIS)

---

Feel free to open an issue or submit a pull request for improvements!
