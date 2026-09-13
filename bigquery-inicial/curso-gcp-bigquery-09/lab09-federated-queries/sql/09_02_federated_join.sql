-- Consulta federada que combina datos analíticos almacenados en BigQuery
-- con datos operacionales dinámicos extraídos de Cloud SQL (PostgreSQL).

SELECT 
  bq.customer_id,
  bq.total_orders,
  bq.total_spent,
  pg.phone_number,
  pg.loyalty_tier,
  pg.address
FROM 
  `lab09_dataset.order_summaries` AS bq
INNER JOIN EXTERNAL_QUERY(
  "us.postgres-conn", -- Formato: 'ubicacion.conexion_id' o 'proyecto.ubicacion.conexion_id'
  "SELECT customer_id, phone_number, loyalty_tier, address FROM customer_profiles;"
) AS pg
ON bq.customer_id = pg.customer_id;