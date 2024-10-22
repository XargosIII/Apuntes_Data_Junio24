-- 1. Todas las películas que su título empieza por A
SELECT title FROM film WHERE title LIKE "A%";
-- 2. Actores cuyo apellido NO comience por B
SELECT last_name FROM actor WHERE last_name NOT LIKE "B%";
-- 3. Películas con 'love' en cualquier parte del título.
SELECT title FROM film WHERE title LIKE "%love%";
-- 4. Direcciones con el campo address2 nulo.
SELECT * FROM address WHERE address2 IS NULL;
-- 5. Películas que NO pertenecen a ninguna de las siguientes categorías: horror, comedia.
-- 6. Clientes que su nombre acaba en N y su apellido contiene ER
-- 7. Películas lanzadas después del año 2000 y que no se han alquilado en 2005
SELECT film.title, film.release_year, rental.return_date
FROM film 
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE film.release_year = 2006 AND year(rental.rental_date) != 2005;
-- 8. Nombre y apellido de todos los actores que han participado en películas de Acción, pero que su nombre no empieza por M.
-- 9. Encuentra todas las películas que su título empieza y acaba con la misma letra.
-- 10. Clientes que no han realizado ningún alquiler durante 2006