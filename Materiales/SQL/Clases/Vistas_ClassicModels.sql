CREATE VIEW pagos_order AS 
    SELECT 
        c.customerNumber, 
        c.customerName,
        e.employeeNumber,
        CONCAT(e.firstName, ' ', e.lastName) AS nombre_empleado,
        (priceEach*quantityOrdered) AS gasto_pedido, 
        o.orderNumber
    FROM orderdetails od
        JOIN orders o
            ON o.orderNumber = od.orderNumber
        JOIN customers c
            ON o.customerNumber = c.customerNumber
        JOIN employees e
            ON c.salesRepEmployeeNumber = e.employeeNumber
    WHERE o.status = "Resolved" OR o.status = "Shipped";