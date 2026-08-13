CREATE VIEW dbo.vw_sales_analysis AS

SELECT
    soh.SalesOrderID,
    sod.SalesOrderDetailID,
    soh.OrderDate,

    soh.CustomerID,

    CASE
        WHEN c.StoreID IS NOT NULL THEN 'Store'
        WHEN c.PersonID IS NOT NULL THEN 'Individual'
        ELSE 'Unknown'
    END AS customer_type,

    ter.[Group] AS territory_group,
    ter.Name AS territory_name,
    ter.CountryRegionCode,

    p.ProductID,
    p.Name AS product_name,
    ps.Name AS subcategory_name,
    pc.Name AS category_name,

    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal AS revenue,

    COALESCE(
        pch.StandardCost,
        p.StandardCost
    ) AS unit_cost,

    COALESCE(
        pch.StandardCost,
        p.StandardCost
    ) * sod.OrderQty AS cogs,

    sod.LineTotal
        - (
            COALESCE(
                pch.StandardCost,
                p.StandardCost
            ) * sod.OrderQty
        ) AS estimated_gross_profit

FROM Sales.SalesOrderHeader AS soh

INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID

INNER JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID

INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID

LEFT JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID

LEFT JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID

LEFT JOIN Sales.SalesTerritory AS ter
    ON soh.TerritoryID = ter.TerritoryID

LEFT JOIN Production.ProductCostHistory AS pch
    ON p.ProductID = pch.ProductID
    AND soh.OrderDate >= pch.StartDate
    AND (
        soh.OrderDate <= pch.EndDate
        OR pch.EndDate IS NULL
    );