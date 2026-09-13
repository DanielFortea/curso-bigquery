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