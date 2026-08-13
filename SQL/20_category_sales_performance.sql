SELECT
    pc.Name AS category_name,

    COUNT(DISTINCT sod.SalesOrderID) AS orders_count,

    SUM(sod.OrderQty) AS units_sold,

    ROUND(SUM(sod.LineTotal), 2) AS revenue,

    ROUND(
        SUM(sod.LineTotal) * 100.0
        / SUM(SUM(sod.LineTotal)) OVER (),
        2
    ) AS revenue_share_pct

FROM Sales.SalesOrderDetail AS sod

INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID

LEFT JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID

LEFT JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID

GROUP BY
    pc.Name

ORDER BY
    revenue DESC;