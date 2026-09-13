-- Consultar la tabla externa de BigQuery apuntando directamente a Cloud Storage
SELECT 
  request_method,
  COUNT(*) AS total_requests,
  AVG(bytes_sent) AS avg_bytes_sent
FROM 
  `curso-gcp-bigquery.lab03_dataset.external_web_logs`
GROUP BY 
  request_method;