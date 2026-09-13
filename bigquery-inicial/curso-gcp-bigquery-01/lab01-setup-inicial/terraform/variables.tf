variable "project_id" {
  type        = string
  description = "El ID del proyecto de Google Cloud"
  default     = "curso-bigquery-508511"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "La región para los recursos compatibles"
}

variable "dataset_id" {
  type        = string
  default     = "lab01_dataset"
  description = "El ID del dataset de BigQuery"
}