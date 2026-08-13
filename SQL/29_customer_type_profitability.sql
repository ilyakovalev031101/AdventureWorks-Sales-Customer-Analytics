WITH sales_financials AS (
    SELECT
        soh.SalesOrderID,

        CASE
            WHEN c.StoreID IS NOT NULL THEN 'Store'
            WHEN c.PersonID IS NOT NULL THEN 'Individual'
            ELSE 'Unknown'
        END AS customer_type,

        sod.OrderQty,

        -- Revenue before discount
        sod.UnitPrice * sod.OrderQty AS gross_sales,

        -- Dollar value of discount
        (sod.UnitPrice * sod.OrderQty) - sod.LineTotal AS discount_amount,

        -- Actual revenue after discount
        sod.LineTotal AS net_sales,

        -- Historical product cost
        COALESCE(
            pch.StandardCost,
            p.StandardCost
        ) * sod.OrderQty AS cogs,

        CASE
            WHEN pch.ProductID IS NULL THEN 1
            ELSE 0
        END AS cost_fallback_flag

    FROM Sales.SalesOrderHeader AS soh

    INNER JOIN Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID

    INNER JOIN Sales.Customer AS c
        ON soh.CustomerID = c.CustomerID

    INNER JOIN Production.Product AS p
        ON sod.ProductID = p.ProductID

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

    COUNT(DISTINCT SalesOrderID) AS orders_count,
    SUM(OrderQty) AS units_sold,

    ROUND(SUM(gross_sales), 2) AS gross_sales,

    ROUND(SUM(discount_amount), 2) AS discount_amount,

    ROUND(
        SUM(discount_amount)
        / NULLIF(SUM(gross_sales), 0) * 100,
        2
    ) AS effective_discount_pct,

    ROUND(SUM(net_sales), 2) AS net_sales,

    ROUND(SUM(cogs), 2) AS cogs,

    ROUND(
        SUM(net_sales - cogs),
        2
    ) AS gross_profit,

    ROUND(
        SUM(net_sales - cogs)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,

    SUM(cost_fallback_flag) AS cost_fallback_lines

FROM sales_financials

GROUP BY customer_type

ORDER BY gross_profit DESC;