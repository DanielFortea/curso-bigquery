resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Lab 04 Dataset"
  description                 = "Dataset para pruebas de Particionado y Clustering"
  location                    = "US"
  default_table_expiration_ms = 360000000 # 1 hora
}

# Tabla con Particionado y Clustering configurados
resource "google_bigquery_table" "transactions_optimized" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "transactions_optimized"

  # Configuración del particionado diario por fecha de transacción
  time_partitioning {
    type  = "DAY"
    field = "transaction_date"
  }

  # Configuración del clustering (se pueden definir hasta 4 campos en orden de prioridad)
  clustering = ["store_id"]

  schema = <<EOF
  [
    {"name": "transaction_id", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "customer_id", "type": "STRING", "mode": "REQUIRED"},
    {"name": "transaction_date", "type": "DATE", "mode": "REQUIRED"},
    {"name": "amount", "type": "FLOAT", "mode": "NULLABLE"},
    {"name": "store_id", "type": "STRING", "mode": "NULLABLE"}
  ]
  EOF
}