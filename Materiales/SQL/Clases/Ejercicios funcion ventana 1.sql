-- 1.C Comparativa de pagos totales de cada mes vs mes anterior
SELECT 
    AÑO, MES, (IMPORTE-IMPORTE_FILA_ANTERIOR) as diferencia
FROM (
    SELECT 
        YEAR(payment_date) as AÑO
        , MONTH(payment_date) as MES
        , SUM(amount) as IMPORTE
        , LAG(SUM(amount),1,0) OVER() as IMPORTE_FILA_ANTERIOR
    FROM payment
    GROUP BY 1,2
) as datos_comparados
WHERE (IMPORTE-IMPORTE_FILA_ANTERIOR) < 0;
-- Tb puedo hacer los calculos en la query del tiron
SELECT 
        YEAR(payment_date) as AÑO
        , MONTH(payment_date) as MES
        , SUM(amount) as IMPORTE
        , LAG(SUM(amount),1,0) OVER() as IMPORTE_FILA_ANTERIOR
        , SUM(amount) - LAG(SUM(amount),1,0) OVER() as DIFERENCIA
    FROM payment
    GROUP BY 1,2;
-- Vamos a coger lo anterior pero la fila que quiero que coja es la del mes anterior segun el calendario    
SELECT    
    YEAR(payment_date) as AÑO
    , MONTH(payment_date) as MES
    , SUM(amount) as IMPORTE
    , LAG(SUM(amount),1,0) OVER(PARTITION BY YEAR(payment_date)) as IMPORTE_MES_ANTERIOR
    FROM payment
    GROUP BY 1,2;
    
-- 2. Película con más actores de cada categoría rankeado por categorías con mas actores en una sola peli.
-- JJ
WITH actor_count AS (
    SELECT 
        c.name category,
        f.title movie,
        COUNT(fa.actor_id) count_of_actors
    FROM film f
    JOIN film_actor fa
        USING(film_id)
    JOIN film_category fc
        USING(film_id)
    JOIN category c
        USING(category_id)
    GROUP BY 
        c.name, f.title
),
ranked_films AS (
    SELECT 
        category,
        movie,
        count_of_actors,
        RANK() OVER (PARTITION BY category ORDER BY count_of_actors DESC) ranking
    FROM actor_count
)
SELECT 
    category,
    movie,
    count_of_actors
FROM ranked_films
WHERE ranking = 1;


-- OTRA MANERA DE HACERLO, creando la venta sobre la tabla agregada directamente
SELECT *
FROM (
    SELECT 
        c.name category
        , f.title movie
        , COUNT(fa.actor_id) count_of_actors
        , RANK() OVER (PARTITION BY c.name ORDER BY COUNT(fa.actor_id) DESC) ranking
    FROM film f
    JOIN film_actor fa
        USING(film_id)
    JOIN film_category fc
        USING(film_id)
    JOIN category c
        USING(category_id)
    GROUP BY 
        c.name, f.title
    ORDER BY 1,3 DESC
) as ranking
WHERE ranking = 1;

-- 3. Pagos acumulados por cliente, con la fecha de cada pago.

SELECT * FROM sakila.payment;

    
SELECT 
    customer_id
    , payment_date
    , amount
    , SUM(amount) OVER (PARTITION BY customer_id, MONTH(payment_date) ORDER BY payment_date) acumulado
    , ROW_NUMBER () OVER ( PARTITION BY  customer_id) as numero_fila
FROM payment;

-- Tabla donde yo pueda ver mes a mes los pagos que ha recibido cada empleado y que porcentaje sobre el total
-- de ese mes acumulado supone. Cosas de objetivos, cuando lo alcanzo, lo rebaso, etc
-- Ejemplo:
--                               SUM(3col)  
--  AÑO | MES | DIA | STAFF_ID | PAYMENTS | % OVER MONTH
-- -----------------------------------------------
-- 2015 | 5   |  1  |    1     |   0.99   |     2%
-- 2015 | 5   |  2  |    1     |   4.99   |     5%
-- 2015 | 5   |  3  |    1     |   12.99  |    18%
-- ...
-- 2015 | 5   |  30 |    1     |   0.99   |   100%

WITH monthly_totals AS (
    SELECT 
        p.staff_id,
        YEAR(p.payment_date) AS año,
        MONTH(p.payment_date) AS mes,
        DAY(p.payment_date) AS dia,
        SUM(p.amount) OVER (PARTITION BY p.staff_id) AS acumulado,
        p.amount AS payment_amount
    FROM payment p
)
SELECT * FROM payment;
-- Penes...asi no voy por notas...

-- Ale, listo leñe, por cada pavo una linea, un año, un mes, un dia, un pago...
WITH total_pagos_empleados_por_mes AS (
    SELECT
        YEAR(payment_date) año
        , MONTH(payment_date) mes
        , staff_id empleados
        , SUM(amount) total_pagado_mes
    FROM payment
    GROUP BY YEAR(payment_date), MONTH(payment_date), staff_id
),
pagos_acumulados_empleados_por_mes AS (
    SELECT
        YEAR(payment_date) año
        , MONTH(payment_date) mes
        , DAY(payment_date) dia
        , staff_id empleado
        , amount pago
        , SUM(amount) OVER (PARTITION BY YEAR(payment_date), MONTH(payment_date), staff_id ORDER BY payment_date) AS pago_acumulado
    FROM payment
)
SELECT
    pe.año
    , pe.mes
    , dia
    , empleado
    , pago
    , pago_acumulado
    , total_pagado_mes
    , CONCAT(ROUND((pe.pago_acumulado / tpm.total_pagado_mes) * 100, 2),"%") AS porcentaje_total_mes
    , ROW_NUMBER () OVER (PARTITION BY pe.año, pe.mes, dia, empleado) as num_transaccion_del_dia
FROM pagos_acumulados_empleados_por_mes pe
JOIN total_pagos_empleados_por_mes tpm 
    ON pe.año = tpm.año AND pe.mes = tpm.mes AND pe.empleado = tpm.empleados
ORDER BY empleado, pe.año, pe.mes, dia;
