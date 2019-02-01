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
#------------------------------------------------------
#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
#------------------------------------------------------
#------------------------------------------------------
#7e. Display the most frequently rented movies in descending order.
#------------------------------------------------------
#------------------------------------------------------


