# MySQL Views — Sakila Database

## Table of Contents

1. [What Is a View?](#1-what-is-a-view)
2. [Why Use Views?](#2-why-use-views)
3. [Types of Views in MySQL](#3-types-of-views-in-mysql)
4. [Syntax Reference](#4-syntax-reference)
5. [The Sakila Schema (Quick Overview)](#5-the-sakila-schema-quick-overview)
6. [View 1 — Film Details (`vw_film_details`)](#6-view-1--film-details)
7. [View 2 — Customer Rental History (`vw_customer_rental_history`)](#7-view-2--customer-rental-history)
8. [View 3 — Actor Film Count (`vw_actor_film_count`)](#8-view-3--actor-film-count)
9. [View 4 — Revenue by Category (`vw_revenue_by_category`)](#9-view-4--revenue-by-category)
10. [View 5 — Overdue Rentals (`vw_overdue_rentals`)](#10-view-5--overdue-rentals)
11. [View 6 — Top Customers (`vw_top_customers`)](#11-view-6--top-customers)
12. [Querying Views](#12-querying-views)
13. [Modifying a View](#13-modifying-a-view)
14. [Dropping a View](#14-dropping-a-view)
15. [View Limitations in MySQL](#15-view-limitations-in-mysql)
16. [Best Practices](#16-best-practices)

---

## 1. What Is a View?

A **view** is a stored SQL `SELECT` statement that is saved in the database with a name and behaves like a virtual table. When you query a view, the database executes the underlying `SELECT` statement and returns the result — no data is physically duplicated.

```
┌──────────────────────────────────────────────────────────┐
│  Client query:  SELECT * FROM vw_film_details            │
│                          │                               │
│                          ▼                               │
│         Database resolves the view definition            │
│                          │                               │
│                          ▼                               │
│   SELECT f.title, l.name, c.name ...                     │
│   FROM film f JOIN language l ... JOIN category c ...    │
│                          │                               │
│                          ▼                               │
│              Result set returned to client               │
└──────────────────────────────────────────────────────────┘
```

---

## 2. Why Use Views?

| Benefit | Explanation |
|---|---|
| **Simplicity** | Hide complex multi-table joins behind a simple name |
| **Security** | Expose only specific columns/rows to a user role |
| **Reusability** | Write a query once and reference it anywhere |
| **Maintainability** | Change the underlying query in one place |
| **Abstraction** | Shield application code from schema changes |

---

## 3. Types of Views in MySQL

### Simple View
Based on a single table with no aggregation. Can be updatable (INSERT/UPDATE/DELETE allowed on the view).

```sql
CREATE VIEW vw_active_customers AS
SELECT customer_id, first_name, last_name, email
FROM customer
WHERE active = 1;
```

### Complex View
Involves JOINs, aggregations (`GROUP BY`), subqueries, `DISTINCT`, or set operators. Generally **read-only** — MySQL cannot safely map a DML statement back to the base tables.

---

## 4. Syntax Reference

### Creating a View

```sql
CREATE [OR REPLACE] VIEW view_name [(column_list)]
AS
    select_statement
[WITH [CASCADED | LOCAL] CHECK OPTION];
```

| Clause | Purpose |
|---|---|
| `OR REPLACE` | Redefines the view if it already exists |
| `column_list` | Optional aliases for the output columns |
| `WITH CHECK OPTION` | Prevents INSERT/UPDATE that would make the row invisible through the view |
| `CASCADED` | (default) Checks all underlying views too |
| `LOCAL` | Checks only this view's WHERE condition |

### Showing a View Definition

```sql
SHOW CREATE VIEW view_name;
```

### Listing All Views in a Schema

```sql
SELECT TABLE_NAME, VIEW_DEFINITION
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'sakila';
```

### Altering a View

```sql
ALTER VIEW view_name AS
    new_select_statement;
```

### Dropping a View

```sql
DROP VIEW [IF EXISTS] view_name;
```

---

## 5. The Sakila Schema (Quick Overview)

The Sakila database models a fictional DVD rental store. The main tables relevant to the views below are:

```
actor ────────────┐
                  │  film_actor ──── film ─── film_category ─── category
                  │                   │
                  │                   └─── inventory ─── rental ─── payment
                  │                                          │
customer ─────────────────────────────────────────────────┘
                                                   └─── staff

film ─── language
customer ─── address ─── city ─── country
```

Key tables:

| Table | Description |
|---|---|
| `film` | Film title, rating, rental rate, length, etc. |
| `actor` | Actor first/last name |
| `film_actor` | Many-to-many link between `film` and `actor` |
| `category` | Genre (Action, Comedy, Drama, …) |
| `film_category` | Many-to-many link between `film` and `category` |
| `language` | Language of the film |
| `customer` | Customer details |
| `rental` | A single rental transaction |
| `inventory` | A physical copy of a film in a store |
| `payment` | Payment record for a rental |
| `staff` | Store employees |

---

## 6. View 1 — Film Details

### Purpose
Provides a single convenient view of every film, enriched with its spoken language and genre category. This removes the need to remember how `film`, `language`, `film_category`, and `category` are joined.

### Tables Joined
`film` → `language` → `film_category` → `category`

### SQL

```sql
CREATE OR REPLACE VIEW vw_film_details AS
SELECT
    f.film_id,
    f.title,
    f.description,
    f.release_year,
    l.name                                     AS language,
    c.name                                     AS category,
    f.rating,
    f.rental_duration,
    f.rental_rate,
    f.length                                   AS length_minutes,
    f.replacement_cost,
    f.special_features
FROM film            f
    INNER JOIN language      l  ON f.language_id        = l.language_id
    INNER JOIN film_category fc ON f.film_id             = fc.film_id
    INNER JOIN category      c  ON fc.category_id        = c.category_id;
```

### How It Works
- Starts from `film` as the driving table.
- Joins `language` to resolve the `language_id` foreign key into a human-readable name.
- Joins through the junction table `film_category` then to `category` to get the genre.

### Example Queries

```sql
-- All Action films rated PG-13
SELECT title, rating, rental_rate
FROM   vw_film_details
WHERE  category = 'Action'
  AND  rating   = 'PG-13'
ORDER  BY title;

-- Average rental rate per category
SELECT   category, ROUND(AVG(rental_rate), 2) AS avg_rate
FROM     vw_film_details
GROUP BY category
ORDER BY avg_rate DESC;

-- Films longer than 2 hours
SELECT title, length_minutes, category
FROM   vw_film_details
WHERE  length_minutes > 120
ORDER  BY length_minutes DESC;
```

---

## 7. View 2 — Customer Rental History

### Purpose
Shows the complete rental history for every customer, including the film rented, rental/return dates, amount paid, and the staff member who processed the transaction. Useful for customer-service lookups and billing audits.

### Tables Joined
`customer` → `address` → `city` → `rental` → `inventory` → `film` → `payment` → `staff`

### SQL

```sql
CREATE OR REPLACE VIEW vw_customer_rental_history AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)     AS customer_name,
    c.email,
    ci.city,
    f.title                                    AS film_title,
    r.rental_date,
    r.return_date,
    CASE
        WHEN r.return_date IS NULL THEN 'Not Returned'
        ELSE 'Returned'
    END                                        AS rental_status,
    DATEDIFF(
        COALESCE(r.return_date, NOW()),
        r.rental_date
    )                                          AS days_rented,
    p.amount                                   AS amount_paid,
    CONCAT(s.first_name, ' ', s.last_name)     AS handled_by
FROM customer   c
    INNER JOIN address   a  ON c.address_id   = a.address_id
    INNER JOIN city      ci ON a.city_id      = ci.city_id
    INNER JOIN rental    r  ON c.customer_id  = r.customer_id
    INNER JOIN inventory i  ON r.inventory_id = i.inventory_id
    INNER JOIN film      f  ON i.film_id      = f.film_id
    LEFT  JOIN payment   p  ON r.rental_id    = p.rental_id
    INNER JOIN staff     s  ON r.staff_id     = s.staff_id;
```

### Design Notes
- `LEFT JOIN payment` is used because a rental may not yet have a corresponding payment row.
- `COALESCE(r.return_date, NOW())` computes days rented for active (unreturned) rentals using today's date.
- The `CASE` expression converts the nullable `return_date` into a readable status string.

### Example Queries

```sql
-- Full rental history for a specific customer
SELECT film_title, rental_date, return_date, rental_status, amount_paid
FROM   vw_customer_rental_history
WHERE  customer_id = 1
ORDER  BY rental_date DESC;

-- All currently unreturned rentals
SELECT customer_name, email, film_title, rental_date, days_rented
FROM   vw_customer_rental_history
WHERE  rental_status = 'Not Returned'
ORDER  BY days_rented DESC;

-- Total spending per customer
SELECT   customer_name, COUNT(*) AS total_rentals, SUM(amount_paid) AS total_spent
FROM     vw_customer_rental_history
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT    10;
```

---

## 8. View 3 — Actor Film Count

### Purpose
Lists every actor alongside the number of films they appear in, their most common film rating, and the categories they are associated with. Good for reporting or front-end actor profile pages.

### Tables Joined
`actor` → `film_actor` → `film` → `film_category` → `category`

### SQL

```sql
CREATE OR REPLACE VIEW vw_actor_film_count AS
SELECT
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name)          AS actor_name,
    COUNT(DISTINCT fa.film_id)                       AS total_films,
    GROUP_CONCAT(DISTINCT c.name ORDER BY c.name
                 SEPARATOR ', ')                     AS categories
FROM actor         a
    INNER JOIN film_actor    fa ON a.actor_id    = fa.actor_id
    INNER JOIN film_category fc ON fa.film_id    = fc.film_id
    INNER JOIN category      c  ON fc.category_id= c.category_id
GROUP BY a.actor_id, a.first_name, a.last_name;
```

### Example Queries

```sql
-- Top 10 most prolific actors
SELECT actor_name, total_films, categories
FROM   vw_actor_film_count
ORDER  BY total_films DESC
LIMIT  10;

-- Actors who appear in Horror films
SELECT actor_name, total_films
FROM   vw_actor_film_count
WHERE  FIND_IN_SET('Horror', categories) > 0
ORDER  BY total_films DESC;
```

---

## 9. View 4 — Revenue by Category

### Purpose
Aggregates total rental revenue broken down by film genre. Useful for business intelligence dashboards showing which categories generate the most income.

### Tables Joined
`category` → `film_category` → `film` → `inventory` → `rental` → `payment`

### SQL

```sql
CREATE OR REPLACE VIEW vw_revenue_by_category AS
SELECT
    c.category_id,
    c.name                          AS category,
    COUNT(DISTINCT f.film_id)       AS total_films,
    COUNT(r.rental_id)              AS total_rentals,
    SUM(p.amount)                   AS total_revenue,
    ROUND(AVG(p.amount), 2)         AS avg_payment
FROM category    c
    INNER JOIN film_category fc ON c.category_id  = fc.category_id
    INNER JOIN film          f  ON fc.film_id      = f.film_id
    INNER JOIN inventory     i  ON f.film_id       = i.film_id
    INNER JOIN rental        r  ON i.inventory_id  = r.inventory_id
    INNER JOIN payment       p  ON r.rental_id     = p.rental_id
GROUP BY c.category_id, c.name;
```

### Example Queries

```sql
-- All categories ranked by revenue
SELECT   category, total_rentals, total_revenue
FROM     vw_revenue_by_category
ORDER BY total_revenue DESC;

-- Categories with more than 1000 rentals
SELECT category, total_rentals, total_revenue
FROM   vw_revenue_by_category
WHERE  total_rentals > 1000;
```

---

## 10. View 5 — Overdue Rentals

### Purpose
Surfaces all rentals that have exceeded the film's allowed rental duration and have not yet been returned. Staff can use this view to identify customers who need to be contacted.

### Tables Joined
`rental` → `inventory` → `film` → `customer` → `address` → `city`

### SQL

```sql
CREATE OR REPLACE VIEW vw_overdue_rentals AS
SELECT
    r.rental_id,
    CONCAT(c.first_name, ' ', c.last_name)          AS customer_name,
    c.email,
    ci.city,
    f.title                                         AS film_title,
    f.rental_duration                               AS allowed_days,
    r.rental_date,
    DATEDIFF(NOW(), r.rental_date)                  AS days_out,
    DATEDIFF(NOW(), r.rental_date)
        - f.rental_duration                         AS days_overdue
FROM rental     r
    INNER JOIN inventory i  ON r.inventory_id  = i.inventory_id
    INNER JOIN film      f  ON i.film_id        = f.film_id
    INNER JOIN customer  c  ON r.customer_id    = c.customer_id
    INNER JOIN address   a  ON c.address_id     = a.address_id
    INNER JOIN city      ci ON a.city_id        = ci.city_id
WHERE r.return_date IS NULL
  AND DATEDIFF(NOW(), r.rental_date) > f.rental_duration;
```

### Example Queries

```sql
-- All overdue rentals sorted by most overdue first
SELECT customer_name, film_title, allowed_days, days_out, days_overdue
FROM   vw_overdue_rentals
ORDER  BY days_overdue DESC;

-- Overdue rentals for a specific city
SELECT customer_name, email, film_title, days_overdue
FROM   vw_overdue_rentals
WHERE  city = 'London'
ORDER  BY days_overdue DESC;

-- Count of overdue rentals per customer
SELECT   customer_name, email, COUNT(*) AS overdue_count
FROM     vw_overdue_rentals
GROUP BY customer_name, email
ORDER BY overdue_count DESC;
```

---

## 11. View 6 — Top Customers

### Purpose
Ranks customers by total money spent, total number of rentals, and average payment per rental. This view is valuable for loyalty program analysis or targeted marketing.

### Tables Joined
`customer` → `address` → `city` → `country` → `rental` → `payment`

### SQL

```sql
CREATE OR REPLACE VIEW vw_top_customers AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)      AS customer_name,
    c.email,
    ci.city,
    co.country,
    COUNT(r.rental_id)                          AS total_rentals,
    SUM(p.amount)                               AS total_spent,
    ROUND(AVG(p.amount), 2)                     AS avg_payment,
    MIN(r.rental_date)                          AS first_rental,
    MAX(r.rental_date)                          AS latest_rental
FROM customer  c
    INNER JOIN address  a   ON c.address_id   = a.address_id
    INNER JOIN city     ci  ON a.city_id      = ci.city_id
    INNER JOIN country  co  ON ci.country_id  = co.country_id
    INNER JOIN rental   r   ON c.customer_id  = r.customer_id
    INNER JOIN payment  p   ON r.rental_id    = p.rental_id
GROUP BY
    c.customer_id, c.first_name, c.last_name,
    c.email, ci.city, co.country;
```

### Example Queries

```sql
-- Top 20 customers by total spend
SELECT customer_name, total_rentals, total_spent
FROM   vw_top_customers
ORDER  BY total_spent DESC
LIMIT  20;

-- Customers from a specific country
SELECT customer_name, city, total_rentals, total_spent
FROM   vw_top_customers
WHERE  country = 'United States'
ORDER  BY total_spent DESC;

-- High-value customers (spent more than $150)
SELECT customer_name, email, total_spent, avg_payment
FROM   vw_top_customers
WHERE  total_spent > 150
ORDER  BY total_spent DESC;
```

---

## 12. Querying Views

Once created, a view is queried exactly like a regular table:

```sql
-- Basic SELECT
SELECT * FROM vw_film_details;

-- With a WHERE filter
SELECT * FROM vw_film_details WHERE category = 'Comedy';

-- With ORDER BY and LIMIT
SELECT * FROM vw_top_customers ORDER BY total_spent DESC LIMIT 5;

-- Aggregate on top of a view
SELECT category, COUNT(*) AS film_count
FROM   vw_film_details
GROUP  BY category;

-- Join a view to a base table
SELECT v.customer_name, v.film_title, f.replacement_cost
FROM   vw_customer_rental_history v
       INNER JOIN film f ON v.film_title = f.title
WHERE  v.rental_status = 'Not Returned';
```

> **Performance note:** MySQL evaluates a view by merging it into the outer query (MERGE algorithm) when possible. For views with `GROUP BY`, `DISTINCT`, or aggregates the TEMPTABLE algorithm is used — the view result is materialised into a temporary table first. For large datasets, consider whether an index-backed base table query or a summary table would be faster.

---

## 13. Modifying a View

Use `CREATE OR REPLACE VIEW` to redefine a view without dropping it first (safest option — no downtime for dependent queries):

```sql
CREATE OR REPLACE VIEW vw_film_details AS
SELECT
    f.film_id,
    f.title,
    l.name   AS language,
    c.name   AS category,
    f.rating,
    f.rental_rate
    -- description and other columns removed in this revision
FROM film            f
    INNER JOIN language      l  ON f.language_id   = l.language_id
    INNER JOIN film_category fc ON f.film_id        = fc.film_id
    INNER JOIN category      c  ON fc.category_id   = c.category_id;
```

Alternatively use `ALTER VIEW`:

```sql
ALTER VIEW vw_film_details AS
SELECT ...;
```

Both statements require the same privileges as `CREATE VIEW`.

---

## 14. Dropping a View

```sql
-- Drop a single view
DROP VIEW IF EXISTS vw_film_details;

-- Drop multiple views in one statement
DROP VIEW IF EXISTS
    vw_film_details,
    vw_customer_rental_history,
    vw_actor_film_count,
    vw_revenue_by_category,
    vw_overdue_rentals,
    vw_top_customers;
```

`IF EXISTS` prevents an error if the view does not exist.

---

## 15. View Limitations in MySQL

| Limitation | Detail |
|---|---|
| **No parameters** | Views cannot accept arguments (use stored procedures for parameterised queries) |
| **No indexes** | You cannot add an index directly to a view |
| **Updatable restrictions** | Views with `JOIN`, `GROUP BY`, `DISTINCT`, `UNION`, subqueries, or aggregate functions are **not updatable** |
| **No ORDER BY guarantee** | Top-level `ORDER BY` inside a view definition is ignored when the view is queried with an outer `ORDER BY` |
| **Recursive views** | MySQL does not support recursive (self-referencing) views |
| **Performance** | TEMPTABLE views bypass the optimizer's ability to use base-table indexes |

---

## 16. Best Practices

- **Prefix with `vw_`** to immediately distinguish views from base tables in queries and ERDs.
- **Use `CREATE OR REPLACE`** instead of `DROP … CREATE` to avoid breaking dependent objects.
- **Avoid `SELECT *`** in view definitions — adding a column to the base table will not automatically appear in the view and can cause confusion.
- **Document every view** with a comment block explaining its purpose, the tables it joins, and intended use cases.
- **Restrict permissions** — grant `SELECT` on a view but not on the underlying sensitive tables when enforcing row- or column-level security.
- **Test performance** with `EXPLAIN` on a view-based query to check whether the MERGE or TEMPTABLE algorithm is used and whether indexes are being utilised.

```sql
-- Check the algorithm MySQL chose for a view query
EXPLAIN SELECT * FROM vw_revenue_by_category WHERE category = 'Action';
```
