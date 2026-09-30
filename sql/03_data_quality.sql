DROP TABLE IF EXISTS data_quality;

CREATE TABLE data_quality AS
WITH snapshots AS (
    SELECT 'T' AS snapshot_id, * FROM snapshot_t
    UNION ALL
    SELECT 'T1' AS snapshot_id, * FROM snapshot_t1
),
checks AS (
    SELECT snapshot_id, 'row_count' AS check_name, COUNT(*) AS value, NULL::VARCHAR AS details
    FROM snapshots GROUP BY snapshot_id
    UNION ALL
    SELECT snapshot_id, 'null_transaction_id', COUNT(*) FILTER (WHERE transaction_id IS NULL), NULL
    FROM snapshots GROUP BY snapshot_id
    UNION ALL
    SELECT snapshot_id, 'duplicate_transaction_id', COUNT(*) - COUNT(DISTINCT transaction_id), NULL
    FROM snapshots GROUP BY snapshot_id
    UNION ALL
    SELECT snapshot_id, 'null_amount', COUNT(*) FILTER (WHERE amount IS NULL), NULL
    FROM snapshots GROUP BY snapshot_id
    UNION ALL
    SELECT snapshot_id, 'negative_amount', COUNT(*) FILTER (WHERE amount < 0), 'Review according to business rules'
    FROM snapshots GROUP BY snapshot_id
    UNION ALL
    SELECT snapshot_id, 'invalid_type', COUNT(*) FILTER (WHERE movement_type IS NULL OR LOWER(TRIM(movement_type)) NOT IN ('entrada','salida')), 'Expected values: entrada/salida'
    FROM snapshots GROUP BY snapshot_id
)
SELECT * FROM checks ORDER BY snapshot_id, check_name;