SELECT
    ter.[Group] AS territory_group,
    ter.Name AS territory_name,

    CASE
        WHEN c.StoreID IS NOT NULL THEN 'Store'
        WHEN c.PersonID IS NOT NULL THEN 'Individual'
        ELSE 'Unknown'
    END AS customer_type,

    COUNT(DISTINCT soh.SalesOrderID) AS orders_count,
    COUNT(DISTINCT soh.CustomerID) AS customers_count,

    ROUND(SUM(soh.SubTotal), 2) AS revenue,

    ROUND(
        AVG(soh.SubTotal),
        2
    ) AS avg_order_value,

    ROUND(
        SUM(soh.SubTotal)
        / SUM(SUM(soh.SubTotal)) OVER (
            PARTITION BY ter.Name
        ) * 100,
        2
    ) AS territory_revenue_share_pct

FROM Sales.SalesOrderHeader AS soh

INNER JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID

LEFT JOIN Sales.SalesTerritory AS ter
    ON soh.TerritoryID = ter.TerritoryID

GROUP BY
    ter.[Group],
    ter.Name,

    CASE
        WHEN c.StoreID IS NOT NULL THEN 'Store'
        WHEN c.PersonID IS NOT NULL THEN 'Individual'
        ELSE 'Unknown'
    END

ORDER BY
    territory_name,
    revenue DESC;