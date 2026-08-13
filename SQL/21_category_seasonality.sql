SELECT
    MONTH(soh.OrderDate) AS month_number,
    DATENAME(MONTH, soh.OrderDate) AS month_name,
    pc.Name AS category_name,

    COUNT(DISTINCT soh.SalesOrderID) AS orders_count,
    SUM(sod.OrderQty) AS units_sold,
    ROUND(SUM(sod.LineTotal), 2) AS revenue

FROM Sales.SalesOrderHeader AS soh

INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID

INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID

LEFT JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID

LEFT JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID

WHERE soh.OrderDate >= '2023-01-01'
  AND soh.OrderDate < '2025-01-01'

GROUP BY
    MONTH(soh.OrderDate),
    DATENAME(MONTH, soh.OrderDate),
    pc.Name

ORDER BY
    month_number,
    category_name;