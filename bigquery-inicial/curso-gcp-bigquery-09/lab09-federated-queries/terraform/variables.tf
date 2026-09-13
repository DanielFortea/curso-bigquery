variable "project_id" {
  type        = string
  description = "El ID del proyecto de Google Cloud"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "La región para la instancia de Cloud SQL"
}

variable "dataset_id" {
  type        = string
  default     = "lab09_dataset"
  description = "El ID del dataset de BigQuery"
}