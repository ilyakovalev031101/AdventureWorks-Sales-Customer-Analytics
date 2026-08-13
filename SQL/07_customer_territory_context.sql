SELECT TOP 100
    soh.SalesOrderID,
    soh.OrderDate,
    c.CustomerID,

    CASE
        WHEN c.PersonID IS NOT NULL THEN 'Individual'
        WHEN c.StoreID IS NOT NULL THEN 'Store'
        ELSE 'Unknown'
    END AS customer_type,

    COALESCE(
        CONCAT(pp.FirstName, ' ', pp.LastName),
        st.Name
    ) AS customer_name,

    ter.Name AS territory_name,
    ter.CountryRegionCode,
    ter.[Group] AS territory_group,

    sod.ProductID,
    p.Name AS product_name,
    sod.OrderQty,
    sod.LineTotal

FROM Sales.SalesOrderHeader AS soh

INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID

INNER JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID

INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID

LEFT JOIN Person.Person AS pp
    ON c.PersonID = pp.BusinessEntityID

LEFT JOIN Sales.Store AS st
    ON c.StoreID = st.BusinessEntityID

LEFT JOIN Sales.SalesTerritory AS ter
    ON soh.TerritoryID = ter.TerritoryID

ORDER BY soh.OrderDate;