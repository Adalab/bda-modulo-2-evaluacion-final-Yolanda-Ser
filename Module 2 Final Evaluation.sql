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
el recuento  */

SELECT rating, COUNT(film_id) AS total_film
	FROM film
    GROUP BY rating;
    
