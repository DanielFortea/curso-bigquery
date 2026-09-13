resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Lab 03 Dataset"
  description                 = "Dataset para pruebas de Tablas Externas"
  location                    = "US"
  default_table_expiration_ms = 3600000000 # 1 hora
}

resource "google_storage_bucket" "gcs_bucket" {
  name          = var.bucket_name
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

# Definición de la Tabla Externa en BigQuery
resource "google_bigquery_table" "external_web_logs" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "external_web_logs"

  external_data_configuration {
    autodetect    = true
    source_format = "CSV"
    
    # Apunta a cualquier archivo CSV que subamos a esa ruta específica
    source_uris   = ["gs://${google_storage_bucket.gcs_bucket.name}/raw/logs/*.csv"]

    csv_options {
      quote             = "\""
      skip_leading_rows = 1
    }
  }
}