SELECT
    s.name AS schema_name,
    t.name AS table_name,
    SUM(p.rows) AS row_count
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
JOIN sys.partitions AS p
    ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
  AND s.name IN ('Sales', 'Production', 'Person')
GROUP BY
    s.name,
    t.name
ORDER BY
    s.name,
    t.name;