SELECT
    pc.Name AS category_name,
    ps.Name AS subcategory_name,
    COUNT(p.ProductID) AS products_count
FROM Production.Product AS p

LEFT JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID

LEFT JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID

GROUP BY
    pc.Name,
    ps.Name

ORDER BY
    pc.Name,
    ps.Name;