SELECT
    pc.Name AS category_name,
    ps.Name AS subcategory_name,

    COUNT(DISTINCT sod.SalesOrderID) AS orders_count,
    SUM(sod.OrderQty) AS units_sold,
    ROUND(SUM(sod.LineTotal), 2) AS revenue,

    ROUND(
        SUM(sod.LineTotal) * 100.0
        / SUM(SUM(sod.LineTotal)) OVER (),
        2
    ) AS total_revenue_share_pct

FROM Sales.SalesOrderDetail AS sod

INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID

INNER JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID

INNER JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID

GROUP BY
    pc.Name,
    ps.Name

ORDER BY revenue DESC;