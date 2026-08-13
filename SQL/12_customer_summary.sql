SELECT
    CustomerID,
    COUNT(DISTINCT SalesOrderID) AS total_orders,
    ROUND(SUM(SubTotal), 2) AS total_revenue,
    ROUND(AVG(SubTotal), 2) AS avg_order_value,
    MIN(OrderDate) AS first_order_date,
    MAX(OrderDate) AS last_order_date
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY total_revenue DESC;