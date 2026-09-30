DROP TABLE IF EXISTS transaction_history;

CREATE TABLE transaction_history AS
SELECT
    transaction_id, movement_date, product, movement_type, fund, amount, 
    description, commercial_name, 'T' AS snapshot_id, 'ACTIVO' AS record_status, TRUE AS is_current
FROM snapshot_t;

INSERT INTO transaction_history
SELECT
    transaction_id, new_movement_date, new_product, new_movement_type, new_fund, new_amount, 
    new_description, new_commercial_name, 'T1' AS snapshot_id, 'ACTIVO' AS record_status, TRUE AS is_current
FROM changes
WHERE change_type IN ('NUEVO','CORREGIDO');

INSERT INTO transaction_history
SELECT
    transaction_id, old_movement_date, old_product, old_movement_type, old_fund, old_amount, 
    old_description, old_commercial_name, 'T1' AS snapshot_id, 'ELIMINADO' AS record_status, TRUE AS is_current
FROM changes
WHERE change_type = 'ELIMINADO';

UPDATE transaction_history h
SET is_current = FALSE
FROM changes c
WHERE h.snapshot_id = 'T'
  AND h.transaction_id = c.transaction_id
  AND c.change_type IN ('CORREGIDO','ELIMINADO');