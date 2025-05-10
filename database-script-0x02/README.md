# database-script-0x02: Seeding Sample Data

This directory contains SQL scripts to populate the AirBnB‑style database with realistic sample data.

## Files

* **seed.sql**: SQL `INSERT` statements to add sample Users, Properties, Bookings, Payments, Reviews, and Messages.
* **README.md**: This overview.

## Prerequisites

* You must have already run `database-script-0x01/schema.sql` to create the schema.
* PostgreSQL connection via `psql` or another SQL client.

## Running the Seed Script

1. **Navigate to directory**

   ```bash
   cd database-script-0x02
   ```

2. **Load seed data**

   ```sql
   \i seed.sql
   ```

3. **Verify inserts**

   ```sql
   SELECT COUNT(*) FROM users;
   SELECT COUNT(*) FROM properties;
   SELECT COUNT(*) FROM bookings;
   SELECT COUNT(*) FROM payments;
   SELECT COUNT(*) FROM reviews;
   SELECT COUNT(*) FROM messages;
   ```

## Sample Data Overview

| Entity     | Sample Rows | Notes                                          |
| ---------- | ----------- | ---------------------------------------------- |
| Users      | 5           | Mix of guests, hosts, and an admin             |
| Properties | 3           | Listings owned by two distinct hosts           |
| Bookings   | 3           | Various statuses: pending, confirmed, canceled |
| Payments   | 2           | Linked to confirmed/canceled bookings          |
| Reviews    | 2           | Ratings between 4 and 5                        |
| Messages   | 3           | Conversation samples between users             |

These inserts illustrate typical interactions in the platform. Feel free to modify or extend for further testing.
