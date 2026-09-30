DROP TABLE IF EXISTS insights;

CREATE TABLE insights AS
SELECT 'cambios_por_tipo' AS insight, change_type AS dimension, COUNT(*) AS metric_value 
FROM changes GROUP BY change_type
UNION ALL
SELECT 'monto_por_tipo_movimiento', COALESCE(LOWER(TRIM(movement_type)),'sin_tipo'), ROUND(SUM(amount),2) 
FROM current_transactions GROUP BY 1, 2
UNION ALL
SELECT 'monto_por_fondo', COALESCE(fund,'SIN_FONDO'), ROUND(SUM(amount),2) 
FROM current_transactions GROUP BY 1, 2
UNION ALL
SELECT 'movimientos_por_producto', COALESCE(product,'SIN_PRODUCTO'), COUNT(*) 
FROM current_transactions GROUP BY 1, 2;