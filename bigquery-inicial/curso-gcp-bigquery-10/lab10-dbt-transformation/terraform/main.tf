resource "google_bigquery_dataset" "raw_dataset" {
  dataset_id                  = "lab10_raw"
  friendly_name               = "Lab 10 Raw Data"
  description                 = "Dataset de datos crudos para transformaciones de dbt"
  location                    = "US"
  default_table_expiration_ms = 360000000 # 1 hora
}

resource "google_bigquery_table" "raw_orders" {
  dataset_id = google_bigquery_dataset.raw_dataset.dataset_id
  table_id   = "raw_orders"

  schema = <<EOF
  [
    {"name": "order_id", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "customer_id", "type": "STRING", "mode": "REQUIRED"},
    {"name": "order_date", "type": "STRING", "mode": "REQUIRED"},
    {"name": "amount", "type": "FLOAT", "mode": "REQUIRED"},
    {"name": "status", "type": "STRING", "mode": "NULLABLE"}
  ]
  EOF
}