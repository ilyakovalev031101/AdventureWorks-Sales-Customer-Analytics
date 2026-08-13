SELECT
    ter.[Group] AS territory_group,
    ter.Name AS territory_name,
    ter.CountryRegionCode,

    COUNT(DISTINCT soh.SalesOrderID) AS orders_count,
    COUNT(DISTINCT soh.CustomerID) AS customers_count,

    ROUND(SUM(soh.SubTotal), 2) AS revenue,

    ROUND(
        SUM(soh.SubTotal)
        / SUM(SUM(soh.SubTotal)) OVER () * 100,
        2
    ) AS revenue_share_pct,

    ROUND(AVG(soh.SubTotal), 2) AS avg_order_value

FROM Sales.SalesOrderHeader AS soh

LEFT JOIN Sales.SalesTerritory AS ter
    ON soh.TerritoryID = ter.TerritoryID

GROUP BY
    ter.[Group],
    ter.Name,
    ter.CountryRegionCode

ORDER BY revenue DESC;