/* EVALUACION FINAL MODULO 2 BASE DE DATOS : SAKILA  */
    
    USE sakila;
    
/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
		(utilizo la clausula DISTINCT para seleccionar valores unicos */

SELECT DISTINCT(title)
	FROM film;
    
/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
		(WHERE condicion que especifico la columna donde igualo su nombre al valor pedido*/
  
SELECT title, rating
	FROM film
    WHERE rating = 'PG-13';


/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción  
		(WHERE + LIKE  condición que especifico la columna y dato exacto a extraer) */

SELECT title, description
	FROM film 
    WHERE description LIKE '%amazing%';
    
/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */

SELECT title, length
	FROM film
	WHERE length>120;

/*5. Recupera los nombres de todos los actores.
		(Con nombres y apellidos)  */

SELECT first_name, last_name
	FROM actor;

/*6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
		(WHERE+LIKE condición que especifico la columna y dato exacto a extraer */

SELECT first_name, last_name
	FROM actor
    WHERE last_name LIKE '%GIBSON%';
    
/*7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
		(WHERE +BETWEEN condición que especifico la columna datos para extraer en el rango solicitado) */

SELECT actor_id, first_name, last_name
	FROM actor
    WHERE actor_id BETWEEN 10 AND 20;
    
/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. */

SELECT title, rating
	FROM film
    WHERE rating NOT IN ('R', 'PG-13');

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con
el recuento
		(# COUNT para hacer el recuento de peliculas creando una columna temporal con AS : alias - total_film
		 # GROUP BY para agrupar por clasificacion)  */

SELECT rating, COUNT(film_id) AS total_film
	FROM film
    GROUP BY rating;
    
/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
apellido junto con la cantidad de películas alquiladas.
		(# Unir 2 tablas : customer con rental. INNER JOIN  une los datos donde aparecen solo los clientes que han alquilado
		 # Utilizo customer_id para su unión) */

SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS total_film_rental
	FROM customer
    	INNER JOIN rental
    	ON customer.customer_id = rental.customer_id
    	GROUP BY customer.customer_id;

/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el
recuento de alquileres.
		(# Desde la tabla category a rental, pasando por film_category, film e inventory
		 # INNER JOIN une las coincidencias de cada tabla
		 # COUNT en la tabla rental, para el recuento de peliculas alquiladas por ID. 
		 # Utilizo en cada tabla las columnas necesarias para datos y las comunes para unir las tablas:
							1.rental -- inventory_id, 2. inventory -- inventory id_, film_id ,
							3. film_category --- film_id, category_id, 4.film -- film_id, 5. category -- category_id)*/ 
           
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
		(# AVG para la media de la duración de las peliculas. GROUP BY para agrupar por clasificacion)  */

SELECT rating, AVG(length) AS average_film_length
	FROM film
	GROUP BY rating;
    
# A la queris anterior, le añado ROUND para redondear a 2 decimales. 

SELECT rating, ROUND(AVG(length), 2) AS average_film_length
	FROM film
	GROUP BY rating;

/*13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
	(# Subconsulta : Uno 2 tablas (film_actor y film) por film_id con WHERE para igualar en la columna title de la tabla film lo solicitado. 
	 # Localizo en las tablas el actor y pelicula y las uno por film_id. )*/

#Querys de suboconsulta: 
SELECT film_actor.actor_id
	FROM film_actor
		INNER JOIN film 
			ON film_actor.film_id = film.film_id
		WHERE film.title = 'Indian Love';
    
# Querys definitiva: 
SELECT  actor.first_name, actor.last_name
	FROM actor
    WHERE actor.actor_id IN (
		SELECT film_actor.actor_id
		FROM film_actor
		INNER JOIN film 
			ON film_actor.film_id = film.film_id
		WHERE film.title = 'Indian Love');
    
 /*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción. 
		(# Se puede utilizar WHERE+LIKE... OR (1º opcion) o con CASE (2º OPCION)
		 # He añadido una columna mediante CASE + END con AS para definir la columna e indique que palabra hay. 
		 # Solo pide el título pero he añadido las 2 columnas para su comprobación) */
 
 SELECT title, description,
			CASE 
				WHEN description LIKE '%dog%' THEN 'dog'
				WHEN description LIKE '%cat%' THEN 'cat'
			END AS special_description
		FROM film
		WHERE description LIKE '%dog%' OR description LIKE '%cat%';

    
/*15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
		(# Subconsulta: los actores de la tabla actor que no esten en la tabla film_actor (en esta ultima tabla estan las peliculas y sus actores) por su columna comun actor_id
		 # El resultado es NULL, es decir que todos los actores SI estan en alguna pelicula.)*/

# 1º Query
SELECT actor_id
	FROM film_actor;
    
# Query final 
SELECT actor.actor_id
	FROM actor
    WHERE actor.actor_id NOT IN (
		SELECT actor_id
		FROM film_actor);
    
/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010  
		(# Tabla film, utilizo BETWEEN con los años indicados en la columna release_year. El resultado es solamente 2006.)*/

/*Comprobación con DISTINT de cuantos diferentes años, por el resultado de solo valor unico*/
SELECT DISTINCT release_year
	FROM film;
    
SELECT title, release_year
	FROM film
    WHERE release_year BETWEEN 2005 AND 2010; 
    
/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".*/
/* 1º opcion:
		(# Utilizo 2 INNER JOIN para unir: a) film_category y film por film_id , b) film_category y category por categori_id. 
		 # Añado WHERE para indicar la condición.) */ 

SELECT film.title, category.name
	FROM film 
		INNER JOIN film_category
			ON film.film_id = film_category.film_id
		INNER JOIN category
			ON film_category.category_id = category.category_id
		WHERE category.name = 'Family';

/* 2º opcion :
		(# Utilizo CTE nombre: category_family)
        
Primera query :  Tabla category selecciono cual es el id de esta categoria = nº 8  */

SELECT category_id
	FROM category
    WHERE name = 'Family';

/*Segunda query...
		(# Necesito el titulo en la tabla film, INNER JOIN para unir esta tabla con film_category, mediante film_id, con la condición 
		   donde la category_id esté en una subcuenta de la tabla category)*/
    
WITH category_family AS (
		SELECT category_id
			FROM category
			WHERE name = 'Family')
SELECT film.title
	FROM film
	INNER JOIN film_category
		ON film.film_id = film_category.film_id 
	WHERE film_category.category_id IN 
    (SELECT category_id FROM category_family);
    
    
    
/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/

/* 1º ocpión:
	Subcuentas : 1.- Tabla film_actor agrupo los ids de actores que esten en mas de 10 peliculas: GROUP BY + HAVING 2.- Uno la subconsulta anterior a la consulta, INNER JOIN con first y last name de Tabla actor */
# 1º query: (200 actores) AS actors_films
SELECT actor_id
	FROM film_actor   
		GROUP BY actor_id
		HAVING COUNT(*)>10;

# Query final:(200 nombres de actores)
SELECT a.first_name, a.last_name
	FROM actor AS a
     INNER JOIN (SELECT f.actor_id
		FROM film_actor  AS F 
			GROUP BY f.actor_id
			HAVING COUNT(*)>10) AS actors_films
			ON a.actor_id =actors_films.actor_id;

/* 2º ocpión
		CTE. Nombre: actors_films
		(* Necesito el titulo en la tabla film, INNER JOIN para unir esta tabla con film_category, mediante film_id, con la condición 
		donde la category_id esté en una subcuenta de la tabla category)*/

# 2 queris previas y de prueba: 
SELECT actor_id
	FROM film_actor   
		GROUP BY actor_id
		HAVING COUNT(*)>10;

SELECT a.first_name, a.last_name
FROM actor AS a
	INNER JOIN actors_films 
		ON a.actor_id = actors_films.actor_id;

# Queris final:
WITH actors_films AS (
	SELECT actor_id
		FROM film_actor   
			GROUP BY actor_id
			HAVING COUNT(*)>10)
SELECT a.first_name, a.last_name
	FROM actor AS a
		INNER JOIN actors_films 
			ON a.actor_id = actors_films.actor_id;

   
/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.*/
		(# WHERE condición que seleccionar la columna igual al dato y en otro caso igual )

SELECT title, rating, length
	FROM film
	WHERE rating = 'R'AND length>120;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
nombre de la categoría junto con el promedio de duración.*/
		(# Tenemos que usar 3 tablas: category, film_category y film uniendolas con INNER JOIN.
		 # AVG: para el promedio de duracion por categoria, agrupando GROUP BY (por categoria)
		 # HAVING filtro mayor a 120 minutos.) 

SELECT category.name, ROUND(AVG(film.length),2) AS average_length
	FROM category
		INNER JOIN film_category
			ON category.category_id = film_category.category_id
		INNER JOIN film 
			ON film_category.film_id= film.film_id
		GROUP BY category.name
		HAVING AVG(film.length)>120;


/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la
cantidad de películas en las que han actuado.*/
	 
SELECT a.first_name, a.last_name, COUNT(*) AS film_count
	FROM actor AS a
		INNER JOIN film_actor AS f
			ON a.actor_id = f.actor_id
		GROUP BY a.actor_id
		HAVING COUNT(*)>5;
 

/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.*/
	(# INNER JOIN : Unir la tabla inventory y film, por film_id y filtramos (WHERE) la subconsulta.
	 # Subconsulta: tenemos que relacionar inventory_id de la tabla rental para filtrar los registros  
	 # DISTINTC en title de la tabla films para eliminar duplicaddos)

# query de subconsulta 
SELECT inventory_id
	FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5;
    
#Query definitiva : 
SELECT DISTINCT title
	FROM film AS f
		INNER JOIN inventory AS i 
		ON f.film_id = i.film_id
		WHERE i.inventory_id IN (
        SELECT inventory_id
			FROM rental
			WHERE DATEDIFF(return_date, rental_date) > 5);
    

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/
	(# 1º query de subconsulta: para extraer los id de los actores que han actuado en la categoria con nombre Horror.
	 # Utilizo 2 INNER JOIN para unir 3 tablas: film_actor con film_category por film_id y tabla categoy con film_category por category_id. Where es el filtro para el nombre de la categoria.  

SELECT actor_id
FROM film_actor 
INNER JOIN film_category
	ON film_actor.film_id = film_category.film_id
INNER JOIN category
	ON film_category.category_id = category.category_id
WHERE category.name = 'Horror';

#2º query definitiva
	# Añado la subconsulta anterior a la selección de los datos solicitados, con WHERE +not in para que excluya los id de los actores que no ...datos solicitados.*/
    
SELECT actor.first_name, actor.last_name
	FROM actor
	WHERE actor_id NOT IN (SELECT actor_id
		FROM film_actor 
			INNER JOIN film_category
				ON film_actor.film_id = film_category.film_id
			INNER JOIN category
				ON film_category.category_id = category.category_id
		WHERE category.name = 'Horror');
        
        
/*24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la  tabla film
	(# CTE peliculas_comedias : selecciono los film_id de las peliculas con categoria son Comedy.  2.- subconsulta que filtra en la tabla category, las category_id que sean comedias
	 # Selecciono los datos pedidos, los titulos en la tabla film que estan con la condicion de la cte. añadiendo la condición de length*/
 
# Queries para añadir en la CTE:
/* SELECT film_id
	FROM film_category
	WHERE category_id + subconsulta  extraccion de comedias;*/

SELECT category_id
FROM category
WHERE name = 'Comedy'


# Query definitiva:
WITH peliculas_comedia AS (
	SELECT film_id
	FROM film_category
	WHERE category_id IN (
		SELECT category_id
		FROM category
 		WHERE name = 'Comedy'))
SELECT title
	FROM film
    WHERE film_id IN (
		SELECT film_id FROM peliculas_comedia)
		AND length > 180;

/*25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe
mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos*/

