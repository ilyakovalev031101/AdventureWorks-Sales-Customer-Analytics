SELECT
    ps.Name AS bike_type,
    MIN(soh.OrderDate) AS first_sale_date,
    MAX(soh.OrderDate) AS last_sale_date,
    COUNT(DISTINCT soh.SalesOrderID) AS total_orders,
    SUM(sod.OrderQty) AS units_sold
FROM Sales.SalesOrderHeader AS soh

INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID

INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID

INNER JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID

INNER JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID

WHERE pc.Name = 'Bikes'

GROUP BY ps.Name

ORDER BY first_sale_date;