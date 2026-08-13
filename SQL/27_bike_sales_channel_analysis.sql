SELECT
    MONTH(soh.OrderDate) AS month_number,
    DATENAME(MONTH, soh.OrderDate) AS month_name,

    CASE
        WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
        ELSE 'Sales-assisted'
    END AS sales_channel,

    COUNT(DISTINCT soh.SalesOrderID) AS orders_count,
    SUM(sod.OrderQty) AS units_sold,

    ROUND(SUM(sod.LineTotal), 2) AS revenue,

    ROUND(
        SUM(CAST(sod.OrderQty AS DECIMAL(10,2)))
        / COUNT(DISTINCT soh.SalesOrderID),
        2
    ) AS units_per_order

FROM Sales.SalesOrderHeader AS soh

INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID

INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID

INNER JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID

INNER JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID

WHERE soh.OrderDate >= '2024-06-01'
  AND soh.OrderDate < '2025-06-01'
  AND pc.Name = 'Bikes'

GROUP BY
    MONTH(soh.OrderDate),
    DATENAME(MONTH, soh.OrderDate),
    soh.OnlineOrderFlag

ORDER BY
    month_number,
    sales_channel;