WITH category_profitability AS (
    SELECT
        CASE
            WHEN c.StoreID IS NOT NULL THEN 'Store'
            WHEN c.PersonID IS NOT NULL THEN 'Individual'
            ELSE 'Unknown'
        END AS customer_type,

        pc.Name AS category_name,

        sod.LineTotal AS revenue,

        COALESCE(
            pch.StandardCost,
            p.StandardCost
        ) * sod.OrderQty AS cogs

    FROM Sales.SalesOrderHeader AS soh

    INNER JOIN Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID

    INNER JOIN Sales.Customer AS c
        ON soh.CustomerID = c.CustomerID

    INNER JOIN Production.Product AS p
        ON sod.ProductID = p.ProductID

    LEFT JOIN Production.ProductSubcategory AS ps
        ON p.ProductSubcategoryID = ps.ProductSubcategoryID

    LEFT JOIN Production.ProductCategory AS pc
        ON ps.ProductCategoryID = pc.ProductCategoryID

    LEFT JOIN Production.ProductCostHistory AS pch
        ON p.ProductID = pch.ProductID
        AND soh.OrderDate >= pch.StartDate
        AND (
            soh.OrderDate <= pch.EndDate
            OR pch.EndDate IS NULL
        )
)

SELECT
    customer_type,
    category_name,

    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(cogs), 2) AS cogs,

    ROUND(
        SUM(revenue - cogs),
        2
    ) AS gross_profit,

    ROUND(
        SUM(revenue - cogs)
        / NULLIF(SUM(revenue), 0) * 100,
        2
    ) AS gross_margin_pct

FROM category_profitability

GROUP BY
    customer_type,
    category_name

ORDER BY
    customer_type,
    gross_profit DESC;