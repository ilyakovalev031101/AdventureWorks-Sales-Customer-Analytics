CREATE VIEW dbo.vw_customer_rfm AS

WITH analysis_date AS (
    SELECT
        DATEADD(
            DAY,
            1,
            MAX(OrderDate)
        ) AS analysis_date
    FROM Sales.SalesOrderHeader
),

customer_metrics AS (
    SELECT
        c.CustomerID,

        CASE
            WHEN c.StoreID IS NOT NULL THEN 'Store'
            WHEN c.PersonID IS NOT NULL THEN 'Individual'
            ELSE 'Unknown'
        END AS customer_type,

        DATEDIFF(
            DAY,
            MAX(soh.OrderDate),
            ad.analysis_date
        ) AS recency_days,

        COUNT(DISTINCT soh.SalesOrderID) AS frequency,

        ROUND(
            SUM(soh.SubTotal),
            2
        ) AS monetary

    FROM Sales.Customer AS c

    INNER JOIN Sales.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID

    CROSS JOIN analysis_date AS ad

    GROUP BY
        c.CustomerID,

        CASE
            WHEN c.StoreID IS NOT NULL THEN 'Store'
            WHEN c.PersonID IS NOT NULL THEN 'Individual'
            ELSE 'Unknown'
        END,

        ad.analysis_date
),

rfm_percentiles AS (
    SELECT
        *,

        PERCENT_RANK() OVER (
            PARTITION BY customer_type
            ORDER BY recency_days DESC
        ) AS r_percentile,

        PERCENT_RANK() OVER (
            PARTITION BY customer_type
            ORDER BY frequency ASC
        ) AS f_percentile,

        PERCENT_RANK() OVER (
            PARTITION BY customer_type
            ORDER BY monetary ASC
        ) AS m_percentile

    FROM customer_metrics
),

rfm_scores AS (
    SELECT
        *,

        CASE
            WHEN r_percentile >= 0.80 THEN 5
            WHEN r_percentile >= 0.60 THEN 4
            WHEN r_percentile >= 0.40 THEN 3
            WHEN r_percentile >= 0.20 THEN 2
            ELSE 1
        END AS r_score,

        CASE
            WHEN f_percentile >= 0.80 THEN 5
            WHEN f_percentile >= 0.60 THEN 4
            WHEN f_percentile >= 0.40 THEN 3
            WHEN f_percentile >= 0.20 THEN 2
            ELSE 1
        END AS f_score,

        CASE
            WHEN m_percentile >= 0.80 THEN 5
            WHEN m_percentile >= 0.60 THEN 4
            WHEN m_percentile >= 0.40 THEN 3
            WHEN m_percentile >= 0.20 THEN 2
            ELSE 1
        END AS m_score

    FROM rfm_percentiles
)

SELECT
    CustomerID,
    customer_type,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,

    CASE
        WHEN r_score >= 4
         AND f_score >= 4
         AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 3
         AND f_score >= 4
            THEN 'Loyal'

        WHEN r_score >= 4
         AND f_score = 1
            THEN 'New / Promising'

        WHEN r_score <= 2
         AND f_score >= 4
         AND m_score >= 4
            THEN 'High Value At Risk'

        WHEN r_score <= 2
         AND f_score >= 4
            THEN 'At Risk'

        WHEN r_score = 1
         AND f_score = 1
            THEN 'Lost'

        ELSE 'Needs Attention'
    END AS customer_segment

FROM rfm_scores;