/*Encontrar los clientes que han gastado por encima de la media (media de gasto de los clientes se entiende)*/
 
 WITH total_gastado_clientes AS(
	SELECT 
		customerNumber
        , SUM(amount) total_gastado
	FROM 
		payments 
	GROUP BY customerNumber
)
, media_todos_clientes AS(
	SELECT 
		AVG(total_gastado) media_total 
    FROM 
		total_gastado_clientes 
)
SELECT 
	customers.customerName
    , customers.customerNumber
    , total_gastado
    , media_total
FROM 
    total_gastado_clientes
JOIN media_todos_clientes
INNER JOIN customers
	ON customers.customerNumber = total_gastado_clientes.customerNumber
WHERE total_gastado > media_total
;
 
-- Y con funciones ventana?

SELECT 
	customers.customerName
    , customers.customerNumber
    , total_gastado
    , media_gasto_global
FROM (
    SELECT 
        customerNumber
        , SUM(amount) OVER(PARTITION BY customerNumber) AS total_gastado
        , AVG(SUM(amount)) OVER() AS media_gasto_global
    FROM payments
    GROUP BY customerNumber
    ORDER BY customerNumber, total_gastado, media_gasto_global
) AS media_y_total_gastado
INNER JOIN customers
	ON customers.customerNumber = media_y_total_gastado.customerNumber
WHERE total_gastado > media_gasto_global;
 
 
/*Dame el ranking por año de los empleados que menos han tenido que trabajar cada año,
puede haber más de un criterio para esto*/

/*Dame el porcentaje de contribución de cada categoría al total de las ventas, porcentaje OJO*/

/* WoW del total acumulado en cuanto a facturas emitidas de los pedidos para el año 2003 y 2004*/

/* MoM de lo mismo*/

/* YoY de lo mismo*/

/* Saca las mismas métricas separadas por cada tienda */

/* ¿Qué porcentaje respecto a la facturación global representa cada una de las tiendas?
Saca esta métrica por cada mes y por cada año*/

-- MODO HARDCORE ON
/* 1. Obtén los 5 clientes que han gastado más dinero en cada país y en cada año, 
junto con el importe total gastado y la media de los días transcurridos entre cada pedido y su correspondiente pago. */

/* 2. Para cada producto, obtén su clasificación (low, medium o high) según el ratio de beneficio (precio de venta - coste)
 y la cantidad de stock disponible, y ordena los productos por clasificación y por precio de venta. */

/* 3. Para cada mes, obtén el número de clientes nuevos (aquellos que han realizado su primer pedido ese mes), 
el número de clientes recurrentes (aquellos que han realizado más de un pedido ese mes) y el porcentaje de clientes recurrentes sobre el total. */

/* 4. Para cada vendedor, obtén el número de pedidos realizados y [[la media de días transcurridos entre el pedido y su correspondiente pago]],
 y ordena los vendedores por el número de pedidos.*/
 
 /* 5. Obtén una tabla con los nombres de los clientes, 
el número de sus pedidos, el importe total de sus pedidos, 
la fecha del primer pedido, la fecha del último pedido. */

/*6. Para cada mes, obtén el número de productos nuevos (aquellos que se han añadido al stock ese mes) 
y [[el número de productos descatalogados (aquellos que han sido eliminados del stock ese mes).]]*/

/* 7. Para cada país y cada año, obtén el número de clientes que han realizado un pedido en el primer trimestre del año 
y no han realizado ningún otro pedido en el resto del año. */

/* 8. Para cada producto, obtén la evolución del stock durante el año, 
indicando para cada mes el stock inicial, las entradas (número de unidades añadidas al stock) 
y las salidas (número de unidades vendidas), y el stock final.*/

/* 9. Para cada cliente, obtén su número de cliente, nombre, 
el importe total gastado en sus pedidos, el número de pedidos realizados, 
el número de productos diferentes comprados y la fecha del último pedido.*/

/* 10. Obtén una tabla con los nombres de los clientes, el número de sus pedidos, 
el importe total de sus pedidos, la fecha del primer pedido, la fecha del último pedido y la media de días transcurridos entre cada pedido 
y su correspondiente pago, pero únicamente para aquellos clientes que han realizado más de 3 pedidos 
y cuyos pedidos no han sido cancelados.*/