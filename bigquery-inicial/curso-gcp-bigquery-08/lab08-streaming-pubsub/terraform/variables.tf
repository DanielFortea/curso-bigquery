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
  default     = "lab08_dataset"
  description = "El ID del dataset de BigQuery"
}

variable "topic_name" {
  type        = string
  default     = "realtime-topic"
  description = "El nombre del tópico de Pub/Sub"
}