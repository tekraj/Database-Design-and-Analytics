## Retrieve Actor Details by Name
```sql 
DELIMITER //

CREATE PROCEDURE GetActorByName(IN search_name VARCHAR(45))
BEGIN
    SELECT actor_id, first_name, last_name
    FROM actor
    WHERE first_name LIKE CONCAT('%', search_name, '%')
       OR last_name LIKE CONCAT('%', search_name, '%');
END //

DELIMITER ;
```

## Calculate Customer Rental Totals
```sql 
DELIMITER //

CREATE PROCEDURE GetCustomerRentalCount(
    IN p_customer_id INT,
    OUT p_rental_count INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_rental_count
    FROM rental
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;
```
## Usages 
```sql
CALL GetCustomerRentalCount(1, @total);
SELECT @total AS RentalCount;
```

## Exercise
1. Create a stored procedure named `GetFilmByCategory` that takes a category name as input and returns the film titles and their release years for that category.
```sql
DELIMITER //
CREATE PROCEDURE GetFilmByCategory(IN category_name VARCHAR(25))
BEGIN
    SELECT f.title, f.release_year
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = category_name;
END //
DELIMITER ;
```
2. Create a stored procedure named `GetCustomerRentalHistory` that takes a customer ID as input and returns the rental history for that customer, including the film title, rental date, and return date.
```sql
DELIMITER //
CREATE PROCEDURE GetCustomerRentalHistory(IN p_customer_id INT)
BEGIN
    SELECT f.title, r.rental_date, r.return_date
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE r.customer_id = p_customer_id;
END //
DELIMITER ;
```