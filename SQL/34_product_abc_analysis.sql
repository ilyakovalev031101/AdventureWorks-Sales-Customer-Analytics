WITH product_sales AS (
    SELECT
        p.ProductID,
        p.Name AS product_name,
        pc.Name AS category_name,
        ps.Name AS subcategory_name,

        COUNT(DISTINCT sod.SalesOrderID) AS orders_count,
        SUM(sod.OrderQty) AS units_sold,
        SUM(sod.LineTotal) AS revenue

    FROM Sales.SalesOrderDetail AS sod

    INNER JOIN Production.Product AS p
        ON sod.ProductID = p.ProductID

    LEFT JOIN Production.ProductSubcategory AS ps
        ON p.ProductSubcategoryID = ps.ProductSubcategoryID

    LEFT JOIN Production.ProductCategory AS pc
        ON ps.ProductCategoryID = pc.ProductCategoryID

    GROUP BY
        p.ProductID,
        p.Name,
        pc.Name,
        ps.Name
),

product_ranking AS (
    SELECT
        *,

        SUM(revenue) OVER (
            ORDER BY revenue DESC, ProductID
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(revenue) OVER () AS total_revenue

    FROM product_sales
)

SELECT
    ProductID,
    product_name,
    category_name,
    subcategory_name,
    orders_count,
    units_sold,

    ROUND(revenue, 2) AS revenue,

    ROUND(
        revenue / NULLIF(total_revenue, 0) * 100,
        2
    ) AS revenue_share_pct,

    ROUND(
        cumulative_revenue / NULLIF(total_revenue, 0) * 100,
        2
    ) AS cumulative_revenue_pct,

    CASE
        WHEN cumulative_revenue / NULLIF(total_revenue, 0) <= 0.80
            THEN 'A'

        WHEN cumulative_revenue / NULLIF(total_revenue, 0) <= 0.95
            THEN 'B'

        ELSE 'C'
    END AS abc_class

FROM product_ranking

ORDER BY
    revenue DESC,
    ProductID;