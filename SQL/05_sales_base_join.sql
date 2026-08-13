SELECT TOP 100
    soh.SalesOrderID,
    soh.OrderDate,
    soh.CustomerID,
    sod.SalesOrderDetailID,
    sod.ProductID,
    p.Name AS product_name,
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
ORDER BY soh.OrderDate;