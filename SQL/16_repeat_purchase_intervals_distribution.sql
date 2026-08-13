WITH order_intervals AS (
    SELECT
        CustomerID,
        OrderDate,

        DATEDIFF(
            DAY,
            LAG(OrderDate) OVER (
                PARTITION BY CustomerID
                ORDER BY OrderDate
            ),
            OrderDate
        ) AS days_since_previous_order

    FROM Sales.SalesOrderHeader
)

SELECT
    CASE
        WHEN days_since_previous_order <= 30 THEN '0-30 days'
        WHEN days_since_previous_order <= 90 THEN '31-90 days'
        WHEN days_since_previous_order <= 180 THEN '91-180 days'
        WHEN days_since_previous_order <= 365 THEN '181-365 days'
        ELSE '365+ days'
    END AS purchase_interval,

    COUNT(*) AS repeat_purchases,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS share_pct

FROM order_intervals
WHERE days_since_previous_order IS NOT NULL

GROUP BY
    CASE
        WHEN days_since_previous_order <= 30 THEN '0-30 days'
        WHEN days_since_previous_order <= 90 THEN '31-90 days'
        WHEN days_since_previous_order <= 180 THEN '91-180 days'
        WHEN days_since_previous_order <= 365 THEN '181-365 days'
        ELSE '365+ days'
    END

ORDER BY MIN(days_since_previous_order);