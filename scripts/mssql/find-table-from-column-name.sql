SELECT
    c.name AS 'ColumnName',
    (SCHEMA_NAME(t.schema_id) + '.' + t.name) AS 'TableName'
FROM
    sys.columns c
    JOIN sys.tables t ON c.object_id = t.object_id
WHERE
    c.name LIKE '%<Your column name here>%'
ORDER BY
    TableName,
    ColumnName;
