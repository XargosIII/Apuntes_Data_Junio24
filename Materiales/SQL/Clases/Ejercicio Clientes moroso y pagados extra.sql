-- Consulta que nos devuelva el cliente que mas le debemos 
-- y el que mas nos deba usando las tablas payments y orders

SELECT * FROM payments;
SELECT * FROM orders;
SELECT * FROM orderdetails;
    
WITH totalPedidos AS (
    SELECT
        o.customerNumber
        , SUM(od.quantityOrdered * od.priceEach) AS totalPedido
    FROM
        orders o
    INNER JOIN 
		orderdetails od ON o.orderNumber = od.orderNumber
    WHERE
        o.status = 'Shipped'
    GROUP BY
        o.customerNumber
),
totalPagos AS (
    SELECT
        p.customerNumber,
        SUM(p.amount) AS totalPagado
    FROM
        payments p
    GROUP BY
        p.customerNumber
),
saldoClientes AS (
    SELECT
        c.customerNumber,
        c.customerName,
        o.totalPedido - p.totalPagado AS saldoCliente
    FROM
        customers c
    INNER JOIN 
		totalPedidos o ON c.customerNumber = o.customerNumber
    LEFT JOIN 
		totalPagos p ON c.customerNumber = p.customerNumber
)
SELECT 
	(SELECT 
		customerName 
	FROM 
		saldoClientes 
	WHERE saldoCliente = (SELECT MAX(saldoCliente) FROM saldoClientes)
	) AS cliente_mas_moroso
    , (SELECT 
		MAX(saldoCliente) 
	FROM 
        saldoClientes
	) AS deuda_del_moroso
    , (SELECT 
		customerName 
    FROM 
		saldoClientes 
    WHERE 
		saldoCliente = (SELECT MIN(saldoCliente) FROM saldoClientes)
    ) AS cliente_mas_pagado
    , (SELECT 
		MIN(saldoCliente) 
    FROM 
		saldoClientes
	) AS cantidad_pagada_extra;

    
