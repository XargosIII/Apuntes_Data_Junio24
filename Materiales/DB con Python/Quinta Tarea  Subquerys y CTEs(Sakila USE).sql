-- 1. Encuentra películas con tarifa de alquiler superior al promedio. 
WITH average_rental_rate AS (
	SELECT 
		ROUND(AVG(rental_rate),2) AS average_rate
	FROM 
		film
)
SELECT 
	film.title
    , film.rental_rate
    , average_rental_rate.average_rate
FROM film
JOIN average_rental_rate
WHERE film.rental_rate > average_rental_rate.average_rate
;

-- 2. Actores que han participado en más películas que el promedio.

SELECT * FROM film_actor;

-- Consulta CTEs

WITH actor_total_films AS(
	SELECT 
		actor_id
		, COUNT(film_id) AS film_count
	FROM 
		film_actor
	GROUP BY 
		actor_id
)
SELECT 
		AVG(film_count) AS avg_films
    FROM 
		actor_total_films;


WITH actor_total_films AS(
	SELECT 
		actor_id
		, COUNT(film_id) AS film_count
	FROM 
		film_actor
	GROUP BY 
		actor_id
)
, actor_average_movies AS (
    SELECT 
		AVG(film_count) AS avg_films
    FROM 
		actor_total_films
)
SELECT 
	actor.actor_id
    , actor.first_name
    , actor.last_name
    , actor_total_films.film_count
FROM actor
JOIN actor_total_films 
	ON actor.actor_id = actor_total_films.actor_id
GROUP BY 
	actor.actor_id
HAVING 
	actor_total_films.film_count > (SELECT avg_films FROM actor_average_movies);

-- 3. Clientes con un total de pagos superior al promedio.

-- Compruebo la media
WITH sum_total_payments AS (
	SELECT 
		customer_id
		, SUM(amount) AS total_payment
	FROM 
		payment
	GROUP BY 
		customer_id
)
SELECT 
	AVG(total_payment) AS avg_payment
FROM 
	sum_total_payments;

-- Resultado
WITH sum_total_payments AS (
	SELECT 
		customer_id
		, SUM(amount) AS total_payment
	FROM 
		payment
	GROUP BY 
		customer_id
) 
, average_payments AS (
    SELECT 
		AVG(total_payment) AS avg_payment
    FROM 
		sum_total_payments
)
SELECT 
    CONCAT(customer.first_name, " ", customer.last_name) AS CLIENT
    , sum_total_payments.total_payment
FROM 
	customer
JOIN 
	sum_total_payments 
ON 
	customer.customer_id = sum_total_payments.customer_id
GROUP BY 
	customer.customer_id
HAVING 
	sum_total_payments.total_payment > (SELECT avg_payment FROM average_payments);

-- 4. Categorías de películas que tienen más de 65 títulos.

WITH films_per_category AS(
SELECT 
	category_id
    , COUNT(film_id) film
FROM film_category
GROUP BY category_id
)

SELECT 
	category.name category
    , fpc.film films
FROM 
	category
INNER JOIN
	films_per_category fpc
	ON category.category_id = fpc.category_id
WHERE
	fpc.film > 65
;

-- 5. Actores que han participado únicamente en películas 'PG-13'

WITH actors_pg13 AS (
    SELECT 
		a.actor_id
        , a.first_name
        , a.last_name
    FROM actor a
    JOIN film_actor fa 
		ON a.actor_id = fa.actor_id
    JOIN film f 
		ON fa.film_id = f.film_id
    WHERE f.rating = 'PG-13'
)
, actors_other_ratings AS (
    SELECT 
		a.actor_id
    FROM actor a
    JOIN film_actor fa 
		ON a.actor_id = fa.actor_id
    JOIN film f 
		ON fa.film_id = f.film_id
    WHERE f.rating != 'PG-13'
)
SELECT 
	a.actor_id
    , a.first_name
    , a.last_name
FROM actors_pg13 a
LEFT JOIN actors_other_ratings o 
	ON a.actor_id = o.actor_id
WHERE o.actor_id != NULL;

SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.rating = 'PG-13'
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(DISTINCT film.rating) = 1;

-- 6. Películas más largas que el promedio.

SELECT 
	CASE 
		WHEN length > (SELECT AVG(length) FROM film) THEN 'por_encima_media'
		ELSE 'por_debajo_media'
	END AS 
    duracion
    , ROUND(COUNT(film_id) * 100 / (SELECT COUNT(*) FROM film), 2) AS porcentaje
FROM 
	film
GROUP BY 
	duracion
;

-- 7. Actores que no han participado en películas de la categoría 'DRAMA'