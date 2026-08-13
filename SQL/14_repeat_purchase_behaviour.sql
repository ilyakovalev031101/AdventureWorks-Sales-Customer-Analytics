WITH customer_orders AS (
    SELECT
        CustomerID,
        SalesOrderID,
        OrderDate,
        SubTotal,

        LAG(OrderDate) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate
        ) AS previous_order_date

    FROM Sales.SalesOrderHeader
),

customer_stats AS (
    SELECT
        CustomerID,

        COUNT(*) AS total_orders,

        ROUND(SUM(SubTotal), 2) AS total_revenue,

        MIN(OrderDate) AS first_order_date,
        MAX(OrderDate) AS last_order_date,

        AVG(
            CAST(
                DATEDIFF(
                    DAY,
                    previous_order_date,
                    OrderDate
                ) AS DECIMAL(10,2)
            )
        ) AS avg_days_between_orders

    FROM customer_orders
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    total_orders,
    total_revenue,
    first_order_date,
    last_order_date,

    DATEDIFF(
        DAY,
        first_order_date,
        last_order_date
    ) AS customer_lifespan_days,

    ROUND(avg_days_between_orders, 2) AS avg_days_between_orders,

    CASE
        WHEN total_orders = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_status

FROM customer_stats
ORDER BY
    total_orders DESC,
    total_revenue DESC;