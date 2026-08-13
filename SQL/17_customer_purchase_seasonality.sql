SELECT
    MONTH(OrderDate) AS month_number,
    DATENAME(MONTH, OrderDate) AS month_name,

    COUNT(DISTINCT SalesOrderID) AS total_orders,
    COUNT(DISTINCT CustomerID) AS unique_customers,

    ROUND(SUM(SubTotal), 2) AS total_revenue,
    ROUND(AVG(SubTotal), 2) AS avg_order_value

FROM Sales.SalesOrderHeader

GROUP BY
    MONTH(OrderDate),
    DATENAME(MONTH, OrderDate)

ORDER BY month_number;