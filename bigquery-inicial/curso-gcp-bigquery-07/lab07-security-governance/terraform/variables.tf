variable "project_id" {
  type        = string
  description = "El ID del proyecto de Google Cloud"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "La región para los recursos compatibles"
}

variable "dataset_id" {
  type        = string
  default     = "lab07_dataset"
  description = "El ID del dataset de BigQuery"
}

variable "owner_email" {
  type        = string
  description = "Tu correo electrónico de GCP para mantener acceso total de administrador"
}