SELECT TOP 100
    soh.SalesOrderID,
    soh.OrderDate,
    soh.CustomerID,
    sod.ProductID,
    p.Name AS product_name,
    ps.Name AS subcategory_name,
    pc.Name AS category_name,
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal
FROM Sales.SalesOrderHeader AS soh

INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID

INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID

LEFT JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID

LEFT JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID

ORDER BY soh.OrderDate;