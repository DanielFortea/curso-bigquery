terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # Configuración del Backend Remoto en Google Cloud Storage
  backend "gcs" {
    bucket = "curso-gcp-bigquery-tfstate"
    prefix = "terraform/state/lab12"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}