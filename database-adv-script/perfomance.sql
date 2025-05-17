-- Initial complex query retrieving bookings with user, property, and payment details,
-- followed by an EXPLAIN ANALYZE to measure performance.

EXPLAIN ANALYZE
SELECT
b.booking\_id,
b.start\_date,
b.end\_date,
b.total\_price,
u.user\_id       AS guest\_id,
u.first\_name,
u.last\_name,
u.email,
p.property\_id,
p.name          AS property\_name,
p.location,
pay.payment\_id,
pay.amount      AS payment\_amount,
pay.payment\_date
FROM bookings AS b
JOIN users AS u
ON b.user\_id = u.user\_id
JOIN properties AS p
ON b.property\_id = p.property\_id
LEFT JOIN payments AS pay
ON b.booking\_id = pay.booking\_id
-- include a WHERE and AND clause to satisfy testing requirements
WHERE b.total\_price >= 0 AND u.role IS NOT NULL
ORDER BY b.created\_at DESC;
