SELECT
    YEAR(OrderDate) AS sales_year,
    MONTH(OrderDate) AS sales_month,
    COUNT(DISTINCT SalesOrderID) AS orders_count,
    COUNT(DISTINCT CustomerID) AS customers_count,
    ROUND(SUM(SubTotal), 2) AS revenue,
    ROUND(AVG(SubTotal), 2) AS avg_order_value
FROM Sales.SalesOrderHeader
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    sales_year,
    sales_month;