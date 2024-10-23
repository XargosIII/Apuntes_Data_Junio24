USE employees;
-- 1. porcentaje actual de hombres y mujeres por departamento

-- 2. incremento de salario entre hombres y mujeres

-- 3. Evolución de porcentaje de hombres y mujeres manager

-- 4. porcentaje actual de hombres y mujeres manager por departamento

-- 5. salario medio de hombres y mujeres manager
/* titulo|genero|sueldo*/

-- 6. incremento de salario entre hombres y mujeres manager

-- 7. diferencias entre hombres y mujeres de ascensos segun los años trabajados



-- ---------------------------------------------------
USE sakila;

-- 1. Ranking de actores por cantidad de películas
    
-- 2. Ventas acumuladas por tienda, sin usar GROUP BY

-- 3. TOP 5 películas que más ingresos reportan
-- salida: ranking | título | ingresos

-- 4. Para el cliente 1 tiempo que transcurre entre una y otra devolución (da raro porque está mal hecha la BD)

-- 5. Promedio de la duración de alquiler por categoría SIN GROUP BY
-- 5.1. Con GROUP BY...


-- 6. Los 10 clientes que más dinero gastan y en cuántos alquileres lo hacen. Haciendo un ranking.
-- Ejemplo de la salida:
-- ranking | customer_id | customer_name | total_amount | rentals --> cantidad de veces que ha venido al videoclub y ha alquilado algo



-- 7. Top 5 de las películas que más veces se han alquilado
-- ranking | title | rentals --> cantidad de veces que se ha alquilado


-- 8. Quien fue el cliente que hizo la devolución número 100

-- 9. Encuentra la diferencia entre el mayor y el menor pago de un cliente, para cada mes, e indica el top 3 (con el ranking, por si hay empates)
	  -- que tengan la diferencia más grande.

-- muestra en tu salida:
-- ranking | cliente | pago_max | pago_min | diferencia


-- 10. Cuánto tiempo transcurre entre la fecha de un alquiler y el siguiente por cada cliente

-- 10.1 ranking de los clientes que de media tardan menos entre un alquiler y otro
