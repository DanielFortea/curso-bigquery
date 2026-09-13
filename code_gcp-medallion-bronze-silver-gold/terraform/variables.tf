variable "project_id" {
  type        = string
  default     = "curso-gcp-medallion"
  description = "El ID del proyecto de GCP donde se desplegarán los recursos."
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Región por defecto para los recursos (Cloud Storage, Firestore)."
}

variable "bq_location" {
  type        = string
  default     = "US"
  description = "Ubicación geográfica para los datasets de BigQuery."
}

variable "github_repository" {
  type        = string
  description = "edumartinez99/curso-gcp-medallion"
}