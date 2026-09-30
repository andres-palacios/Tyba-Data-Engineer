DROP TABLE IF EXISTS changes;

CREATE TABLE changes AS
WITH joined AS (
    SELECT
        COALESCE(t.transaction_id, n.transaction_id) AS transaction_id,
        t.movement_date                              AS old_movement_date,
        t.product                                    AS old_product,
        t.movement_type                              AS old_movement_type,
        t.fund                                       AS old_fund,
        t.amount                                     AS old_amount,
        t.description                                AS old_description,
        t.commercial_name                            AS old_commercial_name,
        n.movement_date                              AS new_movement_date,
        n.product                                    AS new_product,
        n.movement_type                              AS new_movement_type,
        n.fund                                       AS new_fund,
        n.amount                                     AS new_amount,
        n.description                                AS new_description,
        n.commercial_name                            AS new_commercial_name,
        t.transaction_id                             AS old_transaction_id,
        n.transaction_id                             AS new_transaction_id
    FROM snapshot_t t
    FULL OUTER JOIN snapshot_t1 n ON t.transaction_id = n.transaction_id
)
SELECT
    *,
    CASE
        WHEN old_transaction_id IS NULL THEN 'NUEVO'
        WHEN new_transaction_id IS NULL THEN 'ELIMINADO'
        WHEN
            old_movement_date IS NOT DISTINCT FROM new_movement_date AND
            old_product IS NOT DISTINCT FROM new_product AND
            old_movement_type IS NOT DISTINCT FROM new_movement_type AND
            old_fund IS NOT DISTINCT FROM new_fund AND
            old_amount IS NOT DISTINCT FROM new_amount AND
            old_description IS NOT DISTINCT FROM new_description AND
            old_commercial_name IS NOT DISTINCT FROM new_commercial_name
        THEN 'SIN_CAMBIOS'
        ELSE 'CORREGIDO'
    END AS change_type
FROM joined;