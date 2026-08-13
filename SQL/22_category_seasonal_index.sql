WITH monthly_category_sales AS (
    SELECT
        MONTH(soh.OrderDate) AS month_number,
        DATENAME(MONTH, soh.OrderDate) AS month_name,
        pc.Name AS category_name,
        COUNT(DISTINCT soh.SalesOrderID) AS orders_count,
        SUM(sod.OrderQty) AS units_sold,
        SUM(sod.LineTotal) AS revenue
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
)

SELECT
    month_number,
    month_name,
    category_name,
    orders_count,
    ROUND(revenue, 2) AS revenue,

    ROUND(
        revenue /
        AVG(revenue) OVER (
            PARTITION BY category_name
        ) * 100,
        2
    ) AS revenue_seasonal_index

FROM monthly_category_sales

ORDER BY
    category_name,
    month_number;