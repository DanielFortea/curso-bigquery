variable "project_id" {
  type        = string
  description = "El ID del proyecto de Google Cloud"
  default     = "curso-gcp-bigquery"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "La región para los recursos compatibles"
}

variable "dataset_id" {
  type        = string
  default     = "lab02_dataset"
  description = "El ID del dataset de BigQuery"
}

variable "bucket_name" {
  type        = string
  description = "El nombre globalmente único del bucket de Cloud Storage"
}