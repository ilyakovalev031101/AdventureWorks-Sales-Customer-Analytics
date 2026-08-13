WITH monthly_sales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS sales_month,

        COUNT(DISTINCT SalesOrderID) AS orders_count,
        SUM(SubTotal) AS revenue,
        AVG(SubTotal) AS avg_order_value
    FROM Sales.SalesOrderHeader
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
)

SELECT
    sales_month,
    orders_count,
    ROUND(revenue, 2) AS revenue,
    ROUND(avg_order_value, 2) AS avg_order_value,

    ROUND(
        LAG(revenue) OVER (
            ORDER BY sales_month
        ),
        2
    ) AS previous_month_revenue,

    ROUND(
        (
            revenue
            - LAG(revenue) OVER (ORDER BY sales_month)
        )
        /
        NULLIF(
            LAG(revenue) OVER (ORDER BY sales_month),
            0
        ) * 100,
        2
    ) AS revenue_growth_pct

FROM monthly_sales
ORDER BY sales_month;