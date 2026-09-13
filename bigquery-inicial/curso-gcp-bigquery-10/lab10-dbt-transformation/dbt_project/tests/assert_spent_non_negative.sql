-- Test personalizado de dbt: Comprobar que ninguna orden completada tenga un importe negativo.
-- Cualquier fila devuelta por esta consulta se interpretará como un fallo en la integridad de los datos.

SELECT
    order_id,
    amount
FROM {{ ref('stg_raw_orders') }}
WHERE status = 'completed' AND amount < 0