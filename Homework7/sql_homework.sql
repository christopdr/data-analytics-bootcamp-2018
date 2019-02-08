#USE sakila
#SELECT first_name, last_name FROM actor

#SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) as 'Actor Name' FROM actor


#1a. Display the first and last names of all actors from the table actor.
#------------------------------------------------------

SELECT first_name, last_name FROM actor;

#------------------------------------------------------
#1b. Display the first and last name of each actor in a single column in upper case letters. 
#Name the column Actor Name.
#------------------------------------------------------

SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) as 'Actor Name' FROM actor;

#------------------------------------------------------

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name,
# "Joe." What is one query would you use to obtain this information?
#------------------------------------------------------

SELECT ACTOR_ID, FIRST_NAME, LAST_NAME FROM ACTOR
WHERE FIRST_NAME = 'Joe';

#------------------------------------------------------
#2b. Find all actors whose last name contain the letters GEN:
#------------------------------------------------------

SELECT *FROM ACTOR
WHERE LAST_NAME LIKE "%GEN%";

#------------------------------------------------------
#2c. Find all actors whose last names contain the letters LI. This time, order the rows by
#last name and first name, in that order:
#------------------------------------------------------

SELECT LAST_NAME, FIRST_NAME FROM ACTOR
WHERE LAST_NAME  LIKE "%LI%";

#------------------------------------------------------

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan,
# Bangladesh, and China:
#------------------------------------------------------

SELECT COUNTRY_ID, COUNTRY FROM COUNTRY
WHERE COUNTRY IN ('Afghanistan','Bangladesh','China');

#------------------------------------------------------

#3a. You want to keep a description of each actor. You don't think you will be performing
# queries on a description, so create a column in the table actor named description and use the 
#data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
#------------------------------------------------------

ALTER TABLE ACTOR
ADD COLUMN description BLOB;

#------------------------------------------------------

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
#Delete the description column.
#------------------------------------------------------

ALTER TABLE ACTOR
DROP COLUMN description;
SELECT * FROM ACTOR;

#------------------------------------------------------
#4a. List the last names of actors, as well as how many actors have that last name.
#------------------------------------------------------

SELECT LAST_NAME, COUNT(LAST_NAME) AS 'Actors with same last name' FROM ACTOR
GROUP BY LAST_NAME;

#------------------------------------------------------
#4b. List last names of actors and the number of actors who have that last name, but only for 
#names that are shared by at least two actors
#------------------------------------------------------

SELECT LAST_NAME, COUNT(LAST_NAME) AS 'Actors with same last name' FROM ACTOR
GROUP BY LAST_NAME
HAVING COUNT(LAST_NAME) >= 2;
#------------------------------------------------------
#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
#Write a query to fix the record.
#------------------------------------------------------

UPDATE ACTOR
SET FIRST_NAME = 'HARPO'
WHERE FIRST_NAME = 'GROUCHO' AND LAST_NAME = 'WILLIAMS';

#------------------------------------------------------
#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the 
#correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
#------------------------------------------------------

UPDATE ACTOR
SET FIRST_NAME = 'GROUCHO'
WHERE FIRST_NAME = 'HARPO';

#------------------------------------------------------
#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?#
#------------------------------------------------------

SHOW CREATE TABLE ADDRESS;

#------------------------------------------------------
#6a. Use JOIN to display the first and last names, as well as the address, of each staff member.
# Use the tables staff and address:
#------------------------------------------------------

SELECT STAFF.FIRST_NAME, STAFF.LAST_NAME, ADDRESS.ADDRESS FROM STAFF
JOIN ADDRESS ON STAFF.ADDRESS_ID = ADDRESS.ADDRESS_ID;

#------------------------------------------------------
#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
#Use tables staff and payment.
#------------------------------------------------------

SELECT S.STAFF_ID, S.FIRST_NAME, SUM(P.AMOUNT) AS 'TOTAL AMOUNT' FROM PAYMENT AS P
JOIN STAFF AS S ON S.STAFF_ID = P.STAFF_ID
WHERE MONTH(PAYMENT_DATE) = 8 AND YEAR(PAYMENT_DATE) = 2005
GROUP BY S.STAFF_ID;

#------------------------------------------------------
#6c. List each film and the number of actors who are listed for that film. 
#Use tables film_actor and film. Use inner join.
#------------------------------------------------------

SELECT F.TITLE, COUNT(FA.FILM_ID) AS 'ACTORS ON FILM'FROM FILM AS F
INNER JOIN FILM_ACTOR AS FA
ON F.FILM_ID = FA.FILM_ID
GROUP BY FA.FILM_ID;


#------------------------------------------------------
#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
#------------------------------------------------------

SELECT COUNT(I.FILM_ID) AS 'MOVIE COPIES' FROM INVENTORY AS I
WHERE I.FILM_ID = (SELECT FILM_ID FROM FILM
WHERE TITLE = 'Hunchback Impossible');

#------------------------------------------------------
#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
#List the customers alphabetically by last name:
#------------------------------------------------------

SELECT C.FIRST_NAME, C.LAST_NAME, SUM(P.AMOUNT) AS 'TOTAL PAID' FROM CUSTOMER AS C
JOIN PAYMENT AS P ON C.CUSTOMER_ID = P.CUSTOMER_ID
GROUP BY P.CUSTOMER_ID
ORDER BY C.LAST_NAME;

#------------------------------------------------------

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of 
#movies starting with the letters K and Q whose language is English.
#------------------------------------------------------

SELECT * FROM FILM
WHERE TITLE LIKE 'Q%' OR TITLE LIKE 'K%' AND LANGUAGE_ID =
(SELECT LANGUAGE_ID FROM LANGUAGE
WHERE NAME = 'English');

#------------------------------------------------------
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
#------------------------------------------------------

SELECT *FROM ACTOR
WHERE ACTOR_ID IN ( SELECT ACTOR_ID FROM FILM_ACTOR 
					WHERE FILM_ID =(SELECT  FILM_ID FROM FILM
									WHERE TITLE = 'Alone Trip'));

#------------------------------------------------------
#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses
#of all Canadian customers. Use joins to retrieve this information.
#------------------------------------------------------
SELECT FIRST_NAME, LAST_NAME, EMAIL FROM CUSTOMER
LEFT JOIN( SELECT ADDRESS_ID FROM ADDRESS
			INNER JOIN(SELECT CITY_ID FROM CITY 
					INNER JOIN (SELECT COUNTRY_ID FROM COUNTRY
							WHERE COUNTRY = 'Canada') AS C ON CITY.COUNTRY_ID = C.COUNTRY_ID) AS CD 
                            ON ADDRESS.CITY_ID = CD.CITY_ID) AS AD ON CUSTOMER.ADDRESS_ID = AD.ADDRESS_ID;


#------------------------------------------------------
#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
#------------------------------------------------------

SELECT *FROM FILM
WHERE FILM_ID IN (SELECT FILM_ID FROM FILM_CATEGORY WHERE CATEGORY_ID = (SELECT CATEGORY_ID FROM CATEGORY 
												WHERE NAME = 'Family'));

#------------------------------------------------------
#7e. Display the most frequently rented movies in descending order.
#------------------------------------------------------

SELECT FILM.FILM_ID, TITLE, MOST_RENTED.SUM_VAL AS 'MOST RENTED' FROM FILM
JOIN(SELECT TL.FILM_ID, SUM(TL.TOTAL_SUM) AS SUM_VAL FROM (SELECT FILM_ID, RL.TOTAL AS TOTAL_SUM FROM INVENTORY
		JOIN (SELECT INVENTORY_ID, COUNT(INVENTORY_ID) AS TOTAL FROM RENTAL
				GROUP BY INVENTORY_ID) AS RL ON INVENTORY.INVENTORY_ID = RL.INVENTORY_ID) AS TL 
		GROUP BY TL.FILM_ID) AS MOST_RENTED
ON FILM.FILM_ID = MOST_RENTED.FILM_ID
ORDER BY MOST_RENTED.SUM_VAL DESC;


#------------------------------------------------------

#7f. Write a query to display how much business, in dollars, each store brought in.
#------------------------------------------------------


SELECT * FROM (SELECT FILM.FILM_ID AS F_ID, FILM.REPLACEMENT_COST AS F_COST, SUMMARY.STORE_ID AS S_ID, SUMMARY.TOTAL_FILMS AS S_TOTAL FROM FILM
JOIN (SELECT FILM_ID, STORE_ID, COUNT(FILM_ID) AS TOTAL_FILMS FROM INVENTORY
		GROUP BY FILM_ID, STORE_ID) AS SUMMARY
ON FILM.FILM_ID = SUMMARY.FILM_ID) AS DS;
#GROUP BY SUMMARY.STORE_ID

#------------------------------------------------------
#7g. Write a query to display for each store its store ID, city, and country.
#------------------------------------------------------


SELECT SAC.STORE_ID,  SAC.ADDRESS, SAC.DISTRICT, SAC.CITY, CO.COUNTRY FROM (SELECT SA.STORE_ID,  SA.ADDRESS, SA.DISTRICT, C.CITY, C.COUNTRY_ID  FROM (SELECT S.STORE_ID, A.ADDRESS, A.CITY_ID, A.DISTRICT FROM STORE AS S
							LEFT JOIN ADDRESS AS A ON S.ADDRESS_ID = A.ADDRESS_ID) AS SA
			JOIN CITY AS C ON SA.CITY_ID = C.CITY_ID) AS SAC
JOIN COUNTRY AS CO ON SAC.COUNTRY_ID = CO.COUNTRY_ID;
#------------------------------------------------------
#7h. List the top five genres in gross revenue in descending order. (Hint: you may need 
#to use the following tables: category, film_category, inventory, payment, and rental.
#------------------------------------------------------
SELECT *FROM RENTAL
SELECT *FROM INVENTORY
SELECT *FROM CATEGORY
SELECT C.NAME, IRC.CATEGORY_ID, IRC.SUM_RENTAL FROM CATEGORY AS C
RIGHT JOIN (SELECT IR.FILM_ID, FC.CATEGORY_ID, IR.SUM_RENTAL FROM FILM_CATEGORY AS FC
		JOIN (SELECT  I.FILM_ID, R.SUM_RENTAL  FROM INVENTORY AS I
					 JOIN(SELECT INVENTORY_ID, COUNT(INVENTORY_ID) AS SUM_RENTAL FROM RENTAL
								GROUP BY INVENTORY_ID) AS R ON I.INVENTORY_ID = R.INVENTORY_ID) AS IR
		ON FC.FILM_ID = IR.FILM_ID) AS IRC
ON C.CATEGORY_ID = IRC.CATEGORY_ID



#------------------------------------------------------
#8a. In your new role as an executive, you would like to have an easy way of viewing the 
#Top five genres by gross revenue. Use the solution from the problem above to create a view. 
#If you haven't solved 7h, you can substitute another query to create a view.
#------------------------------------------------------
#------------------------------------------------------
#8b. How would you display the view that you created in 8a?
#------------------------------------------------------
#------------------------------------------------------
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
#------------------------------------------------------
#------------------------------------------------------



