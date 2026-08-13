WITH monthly_sales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS sales_month,
        SUM(SubTotal) AS revenue
    FROM Sales.SalesOrderHeader
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
),

monthly_growth AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
),

growth_calculation AS (
    SELECT
        sales_month,
        ROUND(revenue, 2) AS revenue,
        ROUND(
            (revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0) * 100,
            2
        ) AS revenue_growth_pct
    FROM monthly_growth
)

SELECT
    sales_month,
    revenue,
    revenue_growth_pct,

    RANK() OVER (
        ORDER BY revenue_growth_pct DESC
    ) AS growth_rank,

    RANK() OVER (
        ORDER BY revenue_growth_pct ASC
    ) AS decline_rank

FROM growth_calculation
WHERE revenue_growth_pct IS NOT NULL
ORDER BY revenue_growth_pct DESC;