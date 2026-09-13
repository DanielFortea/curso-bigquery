-- Consulta optimizada utilizando filtros de particionado y clustering.
-- BigQuery utilizará 'transaction_date' para descartar particiones y 'store_id' para saltarse datos no deseados dentro de esa partición.

SELECT 
  customer_id,
  SUM(amount) AS total_spent
FROM 
  `curso-gcp-bigquery.lab04_dataset.transactions_optimized`
WHERE 
  transaction_date = '2026-03-03' -- Filtro de particionado (DAY)
  AND store_id = 'STORE_B'        -- Filtro de clustering
GROUP BY 
  customer_id;