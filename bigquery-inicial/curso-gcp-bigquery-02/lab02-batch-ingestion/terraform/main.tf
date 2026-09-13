resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Lab 02 Dataset"
  description                 = "Dataset para pruebas de ingesta en Batch"
  location                    = "US"
  default_table_expiration_ms = 3600000 # 1 hora
}

resource "google_storage_bucket" "gcs_bucket" {
  name          = var.bucket_name
  location      = "US"
  force_destroy = true # Permite destruir el bucket con archivos dentro al ejecutar 'terraform destroy'

  # Regla de ciclo de vida para eliminar archivos antiguos y evitar costes
  lifecycle_rule {
    condition {
      age = 30 # Días
    }
    action {
      type = "Delete"
    }
  }
}