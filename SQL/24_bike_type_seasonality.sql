SELECT
    MONTH(soh.OrderDate) AS month_number,
    DATENAME(MONTH, soh.OrderDate) AS month_name,
    ps.Name AS bike_type,

    COUNT(DISTINCT soh.SalesOrderID) AS orders_count,
    SUM(sod.OrderQty) AS units_sold,
    ROUND(SUM(sod.LineTotal), 2) AS revenue,

    ROUND(
        SUM(sod.LineTotal) /
        AVG(SUM(sod.LineTotal)) OVER (
            PARTITION BY ps.Name
        ) * 100,
        2
    ) AS revenue_seasonal_index

FROM Sales.SalesOrderHeader AS soh

INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID

INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID

INNER JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID

INNER JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID

WHERE soh.OrderDate >= '2023-01-01'
  AND soh.OrderDate < '2025-01-01'
  AND pc.Name = 'Bikes'

GROUP BY
    MONTH(soh.OrderDate),
    DATENAME(MONTH, soh.OrderDate),
    ps.Name

ORDER BY
    bike_type,
    month_number;