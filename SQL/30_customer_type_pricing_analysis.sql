WITH pricing_analysis AS (
    SELECT
        CASE
            WHEN c.StoreID IS NOT NULL THEN 'Store'
            WHEN c.PersonID IS NOT NULL THEN 'Individual'
            ELSE 'Unknown'
        END AS customer_type,

        sod.OrderQty,

        COALESCE(
            plph.ListPrice,
            p.ListPrice
        ) * sod.OrderQty AS list_price_value,

        sod.LineTotal AS actual_revenue,

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

    LEFT JOIN Production.ProductListPriceHistory AS plph
        ON p.ProductID = plph.ProductID
        AND soh.OrderDate >= plph.StartDate
        AND (
            soh.OrderDate <= plph.EndDate
            OR plph.EndDate IS NULL
        )

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

    ROUND(SUM(list_price_value), 2) AS list_price_value,

    ROUND(SUM(actual_revenue), 2) AS actual_revenue,

    ROUND(
        SUM(list_price_value - actual_revenue),
        2
    ) AS total_price_reduction,

    ROUND(
        SUM(list_price_value - actual_revenue)
        / NULLIF(SUM(list_price_value), 0) * 100,
        2
    ) AS effective_price_reduction_pct,

    ROUND(SUM(cogs), 2) AS cogs,

    ROUND(
        SUM(actual_revenue - cogs),
        2
    ) AS gross_profit,

    ROUND(
        SUM(actual_revenue - cogs)
        / NULLIF(SUM(actual_revenue), 0) * 100,
        2
    ) AS gross_margin_pct

FROM pricing_analysis

GROUP BY customer_type

ORDER BY gross_profit DESC;