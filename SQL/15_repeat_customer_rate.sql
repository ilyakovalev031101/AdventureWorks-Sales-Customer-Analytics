WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT SalesOrderID) AS total_orders,
        SUM(SubTotal) AS total_revenue
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
),

customer_segments AS (
    SELECT
        CustomerID,
        total_orders,
        total_revenue,

        CASE
            WHEN total_orders = 1 THEN 'One-time'
            ELSE 'Repeat'
        END AS customer_status

    FROM customer_orders
)

SELECT
    customer_status,
    COUNT(*) AS customers_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct,

    ROUND(SUM(total_revenue), 2) AS total_revenue,

    ROUND(
        SUM(total_revenue) * 100.0
        / SUM(SUM(total_revenue)) OVER (),
        2
    ) AS revenue_share_pct

FROM customer_segments
GROUP BY customer_status
ORDER BY customers_count DESC;