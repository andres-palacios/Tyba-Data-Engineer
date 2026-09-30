-- ==========================================================
-- 1. RESUMEN DE CAMBIOS
-- ==========================================================

SELECT
    change_type,
    COUNT(*) AS total
FROM changes
GROUP BY change_type
ORDER BY total DESC;


-- ==========================================================
-- 2. NUEVOS REGISTROS
-- ==========================================================

SELECT
    transaction_id,
    new_movement_date,
    new_product,
    new_amount,
    new_description
FROM changes
WHERE change_type = 'NUEVO'
ORDER BY transaction_id;


-- ==========================================================
-- 3. REGISTROS ELIMINADOS
-- ==========================================================

SELECT
    transaction_id,
    old_movement_date,
    old_product,
    old_amount,
    old_description
FROM changes
WHERE change_type = 'ELIMINADO'
ORDER BY transaction_id;


-- ==========================================================
-- 4. REGISTROS CORREGIDOS
-- ==========================================================

SELECT
    transaction_id,
    old_amount,
    new_amount,
    old_product,
    new_product,
    old_description,
    new_description
FROM changes
WHERE change_type = 'CORREGIDO'
ORDER BY transaction_id;


-- ==========================================================
-- 5. DATA QUALITY
-- ==========================================================

SELECT
    snapshot_id,
    check_name,
    value,
    details
FROM data_quality
ORDER BY
    snapshot_id,
    check_name;


-- ==========================================================
-- 6. MONTO POR TIPO
-- ==========================================================

SELECT
    movement_type,
    COUNT(*) AS transactions,
    ROUND(SUM(amount),2) AS total_amount
FROM current_transactions
GROUP BY movement_type
ORDER BY total_amount DESC;


-- ==========================================================
-- 7. MONTO POR FONDO
-- ==========================================================

SELECT
    fund,
    COUNT(*) AS transactions,
    ROUND(SUM(amount),2) AS total_amount
FROM current_transactions
GROUP BY fund
ORDER BY total_amount DESC;


-- ==========================================================
-- 8. MOVIMIENTOS POR PRODUCTO
-- ==========================================================

SELECT
    product,
    COUNT(*) AS transactions,
    ROUND(SUM(amount),2) AS total_amount
FROM current_transactions
GROUP BY product
ORDER BY transactions DESC;


-- ==========================================================
-- 9. VER HISTÓRICO
-- ==========================================================

SELECT *
FROM transaction_history
ORDER BY
    transaction_id,
    snapshot_id;

-- ==========================================================
-- 10. VERSIONES ACTUALES
-- ==========================================================

SELECT *
FROM transaction_history
WHERE is_current = TRUE
ORDER BY transaction_id;