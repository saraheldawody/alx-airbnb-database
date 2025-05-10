# ALX Airbnb Database Schema

This directory contains the SQL schema definition for the Airbnb-style application.

## Repository Structure

```
database-script-0x01/
├── schema.sql      # DDL statements to create tables, constraints, and indexes
└── README.md       # This documentation file
```

## Prerequisites

* PostgreSQL 12 or higher
* `pgcrypto` extension enabled for UUID generation

## Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/alx-airbnb-database.git
   cd alx-airbnb-database/database-script-0x01
   ```

2. **Apply the schema**

   ```bash
   psql -d your_database -f schema.sql
   ```

## Schema Overview

* **User**: Stores guests, hosts, and admins with unique emails and roles.
* **Property**: Listings tied to hosts, with pricing and location details.
* **Booking**: Reservation records linking users and properties, with status and date checks.
* **Payment**: Payment records linked to bookings, with method and timestamp.
* **Review**: Ratings and comments per property by users.
* **Message**: User-to-user messaging between guests and hosts.

## Indexes

Additional indexes are created on foreign keys and frequently queried columns (e.g., email) to optimize performance.

## Notes

* `total_price` is not stored; calculate dynamically as `price_per_night * (end_date - start_date)`.
* Adjust `location` handling if more granular geographic queries are needed.
