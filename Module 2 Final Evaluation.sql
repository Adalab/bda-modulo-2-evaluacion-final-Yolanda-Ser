/* EVALUACION FINAL MODULO 2
	BASE DE DATOS : SAKILA  */
    
    USE sakila;
    
/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
 ( utilizo la clausula DISTINCT para seleccionar valores unicos */

SELECT DISTINCT(title)
	FROM film;
    
/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
( utilizo el operador de comparación WHERE que especifica la columna donde igualo su nombre al valor pedido. Tambien podemos agrupar por titulo con GROUP BY ) 

OPCION 1:  */ 
SELECT title, rating
	FROM film
    WHERE rating = 'PG-13';

/* OPCION 2:  */ 
SELECT title, rating
	FROM film
	WHERE rating = 'PG-13'
	ORDER BY film_id;

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción  
(utilizo WHERE + LIKE para buscar en los registros de la columna en los que solo aparezca la palabra con '%' que contiene la palabra amazing) */

SELECT title, description
	FROM film 
    WHERE description LIKE '%amazing%';
    
/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */

SELECT title, length
	FROM film
	WHERE length>120;

/*5. Recupera los nombres de todos los actores.
(he recuperado todos los nombres y apellidos)  */

SELECT first_name, last_name
	FROM actor;

/*6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
( WHERE -  LIKE selecciono en la columna apellido con WHERE y busco los registros que solo tienen el dato pedido con LIKE y detallando el parametro '% %' */

SELECT first_name, last_name
	FROM actor
    WHERE last_name LIKE '%GIBSON%';
    
/*7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
(Utilizo BETWEEN para pedir en la columna ID, los registros incluidos los especificados en el rango  ) */

SELECT actor_id, first_name, last_name
	FROM actor
    WHERE actor_id BETWEEN 10 AND 20;
    
/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. */

SELECT title, rating
	FROM film
    WHERE rating NOT IN ('R', 'PG-13');

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con
el recuento
#  COUNT para hacer el recuento de peliculas creando una columna temporal con AS : alias - total_film
#  GROUP BY para agrupar por clasificacion  */

SELECT rating, COUNT(film_id) AS total_film
	FROM film
    GROUP BY rating;
    
/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
apellido junto con la cantidad de películas alquiladas.
# Unir 2 tablas : customer con rental. INNER JOIN  une los datos donde aparecen solo los clientes que han alquilado
# Utilizo customer_id para su unión */

SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS total_film_rental
	FROM customer
    INNER JOIN rental
    ON customer.customer_id = rental.customer_id
    GROUP BY customer.customer_id;

/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el
recuento de alquileres.
 # Desde la tabla category a rental, pasando por film_category, film e inventory
 # INNER JOIN une las coincidencias de cada tabla
 # COUNT en la tabla rental, para el recuento de peliculas alquiladas por ID. 
  # Utilizo en cada tabla las columnas necesarias para datos y las comunes para unir las tablas :
           1.rental -- rental_id, inventory_id, 2. inventory -- inventory id_, film_id ,
           3. film_category --- film_id, category_id, 4.film -- film_id, 5. category -- category_id*/ 
           
SELECT category.category_id, category.name, COUNT(rental.rental_id) AS total_film_rental
	FROM category
	INNER JOIN film_category
	ON category.category_id = film_category.category_id
    INNER JOIN inventory
	ON film_category.film_id = inventory.film_id
	INNER JOIN rental 
    ON inventory.inventory_id = rental.inventory_id
	GROUP BY category_id;
    
/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
clasificación junto con el promedio de duración. 
# AVG para la media de la duración de las peliculas.
# GROUP BY para agrupar por clasificacion  */

SELECT rating, AVG(length) AS average_film_length
	FROM film
	GROUP BY rating;
    
# A la queris anterior, le añado ROUND para redondear a 2 decimales. 

SELECT rating, ROUND(AVG(length), 2) AS average_film_length
FROM film
GROUP BY rating;

/*13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
 # Subconsulta : 1.- Uno 2 tablas (film_actor y film) por film_id con WHERE para igualar en la columna title de la tabla film lo solicitado. 
				 2.- Toda la queris anterior es la subconsulta para que pueda darme los nombres y apellidos de la tabla actores 
 
 */
# Localizo en las tablas el actor y pelicula y las uno por film_id. 
SELECT film_actor.actor_id
	FROM film_actor
	INNER JOIN film 
    ON film_actor.film_id = film.film_id
	WHERE film.title = 'Indian Love';
    
# Me piden nombre y apellidos de actores,  (tabla actores), uno con la queris anterior como subconsulta: 

SELECT  actor.first_name, actor.last_name
	FROM actor
    WHERE actor.actor_id IN (SELECT film_actor.actor_id
	FROM film_actor
	INNER JOIN film 
    ON film_actor.film_id = film.film_id
	WHERE film.title = 'Indian Love');
    
 /*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción. 
 # Se puede utilizar WHERE+LIKE... OR (1º opcion) o con CASE (2º OPCION)
 # He añadido una columna mediante CASE + END con AS para definir la columna e indique que palabra hay. 
 # Solo pide el título pero he añadido las 2 columnas para su comprobación */
 
 SELECT title, description,
			CASE 
				WHEN description LIKE '%dog%' THEN 'dog'
				WHEN description LIKE '%cat%' THEN 'cat'
			END AS special_description
    FROM film
	WHERE description LIKE '%dog%' OR description LIKE '%cat%';

    
/*15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.*/
# Subconsulta: los actores de la tabla actor que no esten en la tabla film_actor (en esta ultima tabla estan las peliculas y sus actores) por su columna comun actor_id
# El resultado es NULL, es decir que todos los actores si estan en alguna pelicula. 
SELECT actor_id
	FROM film_actor;

SELECT actor.actor_id
	FROM actor
    WHERE actor.actor_id NOT IN (SELECT actor_id
	FROM film_actor);
    
    