-- 1. Según cuántos alquileres haya hecho el cliente clasifícalo en: Premium, Regular, Nuevo.
        -- Premium: más de 30 alquileres
        -- Regular: entre 10 y 30
        -- Nuevo: entre 0 y 10
        
SELECT customer.customer_id, customer.first_name, customer.last_name,
	CASE 
		WHEN COUNT(rental_id) > 30 THEN 'Premium'
		WHEN COUNT(rental_id) BETWEEN 10 AND 30 THEN 'Regular'
		WHEN COUNT(rental_id) BETWEEN 0 AND 9 THEN 'New'
		ELSE 'ERROR'
	END AS classification,
    COUNT(rental_id) AS total_rentals
FROM customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;
        
-- 2. Añade un prefijo al título según su clasificación.
        -- Ejemplo: para la clasificación G, 'Familiar - Titulo_de_la_película'

SELECT distinct rating FROM film;

SELECT title,
	CASE
		WHEN rating = 'G' THEN CONCAT('General Audiences - ', title)
		WHEN rating = 'PG' THEN CONCAT('Parental Guidance - ', title)
		WHEN rating = 'PG-13' THEN CONCAT('Parents Cautioned - ', title)
        WHEN rating = 'R' THEN CONCAT('Restricted - ', title)
        WHEN rating = 'NC-17' THEN CONCAT('Adults Only - ', title)
		ELSE CONCAT('Unclassified - ', title)
	END AS classified_title
FROM film;

SELECT first_name, last_name, CONCAT(first_name, " ", last_name) AS name_name FROM actor;

-- 3. Para las películas de la categoría 1 y 2 aplica un descuento en su rental_rate de 10% y 15% respectivamente.

SELECT * FROM film;

SELECT  film.title, film_category.category_id, film.rental_rate,
	CASE 
		WHEN film_category.category_id = 1 THEN ROUND(film.rental_rate * 0.9, 2)
		WHEN film_category.category_id = 2 THEN ROUND(film.rental_rate * 0.85, 2)
		ELSE rental_rate
	END AS discounted_rate
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id;

-- 4. Películas con clasificación 'G', añade 5 años a su año de estreno.

SELECT title, rating, release_year,
	CASE 
		WHEN rating = 'G' THEN release_year + 5
		ELSE release_year
	END AS blueray_release_year
FROM film;
-- ORDER BY rating;

-- 5. Clasifica, según el tiempo que ha estado alquilada una película, si tiene que pagar o no multa.
        -- Multa para una diferencia superior a 3 días
        
SELECT rental_id, rental_date, return_date,
	CASE 
		WHEN DATEDIFF(return_date, rental_date) > 3 THEN 'Fine'
        WHEN DATEDIFF(return_date, rental_date) BETWEEN 0 AND 3 THEN 'Clear'
		ELSE 'ERROR'
	END AS fines,
    DATEDIFF(return_date, rental_date) AS datediff
FROM rental;

-- 6. Clasifica los actores en función de la cantidad de películas en las que ha participado. 
	-- Veterano: más de 20
	-- Experimentado: entre 10 y 20
	-- Novato: menos de 10
    
SELECT * FROM film_actor;
SELECT COUNT(actor_id) FROM film_actor GROUP BY actor_id;
    
SELECT actor.actor_id, actor.first_name, actor.last_name,
	CASE 
		WHEN COUNT(film_actor.film_id) > 20 THEN 'Veteran'
		WHEN COUNT(film_actor.film_id) BETWEEN 10 AND 20 THEN 'Experienced'
		ELSE 'Junior'
	END AS actor_rank,
    COUNT(film_actor.film_id) as film_count
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id;
        
-- 7. Muestra una nueva columna con un incremento del 15% en el precio de alquiler de una película si dura más de 120 minutos

SELECT * FROM film;

SELECT  title, length, rental_rate,
	CASE 
		WHEN length > 120 THEN ROUND(rental_rate * 1.15, 2)
		ELSE rental_rate
	END AS premium_rental
FROM film;

-- 8. Premia a los clientes con puntos en función de la cantidad de alquileres que haya hecho:
        -- 100 si ha alquilado más de 20 veces
        -- 50 si lo ha hecho entre 10 y 20 veces
        -- 10 si lo ha hecho menos de 10 veces

SELECT customer.customer_id, customer.first_name, customer.last_name,
	COUNT(rental.rental_id) AS rented_films,
	CASE 
		WHEN COUNT(rental.rental_id) > 20 THEN 100
		WHEN COUNT(rental.rental_id) BETWEEN 10 AND 20 THEN 50
		ELSE 10
	END AS premium_points
FROM customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer_id
ORDER BY rented_films;

-- 9. Clasifica los alquileres por prioridad 'Alta', 'Normal' y ordena la lista para que salgan los de alta prioridad en primer lugar.
        -- Clientes VIP son aquellos que pertenecen a la tienda 1
        
SELECT 
	r.rental_id
    , r.customer_id
    , i.film_id
    , i.store_id
    , CASE 
		WHEN i.store_id = 1 THEN 'HIGH - VIP Client'
		ELSE 'Normal - Meh Client'
	END AS priority
FROM rental AS r
INNER JOIN inventory AS i on i.inventory_id = r.inventory_id;
-- ORDER BY priority DESC;