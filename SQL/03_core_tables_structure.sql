SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE
    (TABLE_SCHEMA = 'Sales' AND TABLE_NAME IN (
        'SalesOrderHeader',
        'SalesOrderDetail',
        'Customer',
        'SalesTerritory'
    ))
    OR
    (TABLE_SCHEMA = 'Production' AND TABLE_NAME IN (
        'Product',
        'ProductSubcategory',
        'ProductCategory'
    ))
    OR
    (TABLE_SCHEMA = 'Person' AND TABLE_NAME = 'Person')
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME,
    ORDINAL_POSITION;