WITH customer_stats AS (
    SELECT
        c.CustomerID,

        CASE
            WHEN c.StoreID IS NOT NULL THEN 'Store'
            WHEN c.PersonID IS NOT NULL THEN 'Individual'
            ELSE 'Unknown'
        END AS customer_type,

        COUNT(DISTINCT soh.SalesOrderID) AS total_orders,
        SUM(soh.SubTotal) AS total_revenue

    FROM Sales.Customer AS c

    INNER JOIN Sales.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID

    GROUP BY
        c.CustomerID,
        CASE
            WHEN c.StoreID IS NOT NULL THEN 'Store'
            WHEN c.PersonID IS NOT NULL THEN 'Individual'
            ELSE 'Unknown'
        END
)

SELECT
    customer_type,

    CASE
        WHEN total_orders = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_status,

    COUNT(*) AS customers_count,

    ROUND(SUM(total_revenue), 2) AS total_revenue,

    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue

FROM customer_stats

GROUP BY
    customer_type,
    CASE
        WHEN total_orders = 1 THEN 'One-time'
        ELSE 'Repeat'
    END

ORDER BY
    customer_type,
    customer_status;