resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Lab 05 Dataset"
  description                 = "Dataset para analisis de SQL Avanzado"
  location                    = "US"
  default_table_expiration_ms = 360000000 # 1 hora
}

resource "google_bigquery_table" "ecommerce_sales" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "ecommerce_sales"

  schema = <<EOF
  [
    {"name": "sale_id", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "customer_id", "type": "STRING", "mode": "REQUIRED"},
    {"name": "sale_date", "type": "DATE", "mode": "REQUIRED"},
    {"name": "amount", "type": "FLOAT", "mode": "REQUIRED"},
    {"name": "product_category", "type": "STRING", "mode": "NULLABLE"}
  ]
  EOF
}