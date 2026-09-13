terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 4.0" }
  }
}

provider "google" {
  project = "curso-gcp-dbt"
  region  = "europe-southwest1" # Madrid
}

# Dataset para los datos crudos (Ingesta)
resource "google_bigquery_dataset" "raw_ecommerce" {
  dataset_id                  = "raw_ecommerce"
  location                    = "EU"
  delete_contents_on_destroy  = true
}

# Dataset para desarrollo de dbt
resource "google_bigquery_dataset" "dbt_dev" {
  dataset_id                  = "dbt_dev"
  location                    = "EU"
  delete_contents_on_destroy  = true
}