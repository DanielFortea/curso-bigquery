resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Lab 06 Dataset"
  description                 = "Dataset para BigQuery ML"
  location                    = "US" # BigQuery ML se ejecuta óptimamente en ubicaciones multirregión
  default_table_expiration_ms = 360000000 # 1 hora
}

resource "google_bigquery_table" "customer_features" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "customer_features"

  schema = <<EOF
  [
    {"name": "customer_id", "type": "STRING", "mode": "REQUIRED"},
    {"name": "age", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "loyalty_years", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "total_previous_orders", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "yearly_spend", "type": "FLOAT", "mode": "REQUIRED"}
  ]
  EOF
}