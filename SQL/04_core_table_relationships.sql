SELECT
    fk.name AS foreign_key_name,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) AS child_schema,
    OBJECT_NAME(fk.parent_object_id) AS child_table,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS child_column,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS parent_schema,
    OBJECT_NAME(fk.referenced_object_id) AS parent_table,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS parent_column
FROM sys.foreign_keys AS fk
JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
WHERE
    OBJECT_NAME(fk.parent_object_id) IN (
        'SalesOrderHeader',
        'SalesOrderDetail',
        'Customer',
        'SalesTerritory',
        'Product',
        'ProductSubcategory',
        'ProductCategory',
        'Person'
    )
ORDER BY
    child_schema,
    child_table,
    foreign_key_name;