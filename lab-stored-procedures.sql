-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the following query:
select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;
  
-- Converting the query into a simple stored procedure:
DELIMITER //
create procedure customers_action_films ()
begin 
select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;
end //
DELIMITER ;

call customers_action_films;

-- Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.
DELIMITER //
create procedure customers_any_films (in film char(30))
begin 
select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = film
group by first_name, last_name, email;
end //
DELIMITER ;

call customers_any_films ('Action');
call customers_any_films ('Animation');
call customers_any_films ('Children');
call customers_any_films ('Classics');
call customers_any_films ('Comedy');
call customers_any_films ('Documentary');
-- Etc., there are 16 distinct genres and the input can be any of them just using its name.

-- Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.
select c.name, count(fc.film_id)
from sakila.category c join sakila.film_category fc using (category_id)
group by c.name
order by count(fc.film_id) asc;

DELIMITER //
create procedure most_numerous_genres (in x int)
begin 
select c.name
from sakila.category c join sakila.film_category fc using (category_id)
group by c.name
having count(fc.film_id) > x 
order by count(fc.film_id) asc;
end //
DELIMITER ;

call most_numerous_genres (65);
