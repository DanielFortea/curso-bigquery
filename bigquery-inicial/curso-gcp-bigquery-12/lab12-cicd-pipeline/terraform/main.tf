resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Lab 12 CI-CD Dataset"
  description                 = "Dataset desplegado de forma automatica mediante GitHub Actions"
  location                    = "US"
  default_table_expiration_ms = 360000000 # 1 hora
}