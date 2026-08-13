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
)

SELECT
    CustomerID,
    SalesOrderID,
    OrderDate,
    previous_order_date,

    DATEDIFF(
        DAY,
        previous_order_date,
        OrderDate
    ) AS days_since_previous_order,

    ROUND(SubTotal, 2) AS order_value

FROM customer_orders
WHERE previous_order_date IS NOT NULL
ORDER BY
    CustomerID,
    OrderDate;