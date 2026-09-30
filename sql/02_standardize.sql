DROP TABLE IF EXISTS snapshot_t;
DROP TABLE IF EXISTS snapshot_t1;

CREATE TABLE snapshot_t AS
SELECT
    CAST(id_cliente AS VARCHAR)         AS transaction_id,
    CAST(date AS VARCHAR)               AS movement_date,
    CAST(product AS VARCHAR)            AS product,
    CAST(type AS VARCHAR)               AS movement_type,
    CAST(fund AS VARCHAR)               AS fund,
    CAST(amount AS DOUBLE)              AS amount,
    CAST(description AS VARCHAR)        AS description,
    CAST(commercial_name AS VARCHAR)    AS commercial_name,
    'T'                                 AS snapshot_id
FROM raw_t;

CREATE TABLE snapshot_t1 AS
SELECT
    CAST(id_cliente AS VARCHAR)                 AS transaction_id,
    CAST(date AS VARCHAR)                       AS movement_date,
    CAST(product AS VARCHAR)                    AS product,
    CAST(type AS VARCHAR)                       AS movement_type,
    CAST(fund AS VARCHAR)                       AS fund,
    CAST(amount AS DOUBLE)                      AS amount,
    CAST(description AS VARCHAR)                AS description,
    CAST(commercial_name AS VARCHAR)            AS commercial_name,
    'T1'                                        AS snapshot_id
FROM raw_t1;