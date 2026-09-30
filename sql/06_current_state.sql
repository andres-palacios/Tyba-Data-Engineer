DROP TABLE IF EXISTS current_transactions;

CREATE TABLE current_transactions AS
SELECT
    transaction_id, movement_date, product, movement_type, fund, amount, 
    description, commercial_name, snapshot_id
FROM snapshot_t1;