# Obtener información del proyecto para recuperar el número de proyecto de forma dinámica
data "google_project" "project" {}

# Forzar la creación del agente de servicio (service identity) para Pub/Sub usando google-beta
resource "google_project_service_identity" "pubsub_agent" {
  provider = google-beta
  project  = var.project_id
  service  = "pubsub.googleapis.com"
}

# 1. Dataset de BigQuery
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Lab 08 Dataset"
  description                 = "Dataset para ingesta en tiempo real con Pub/Sub"
  location                    = "US"
  default_table_expiration_ms = 360000000 # 1 hora
}

# 2. Tabla destino (los campos deben coincidir con las claves del JSON enviado a Pub/Sub)
resource "google_bigquery_table" "realtime_events" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "realtime_events"

  schema = <<EOF
  [
    {"name": "event_id", "type": "STRING", "mode": "REQUIRED"},
    {"name": "event_type", "type": "STRING", "mode": "REQUIRED"},
    {"name": "user_id", "type": "STRING", "mode": "REQUIRED"},
    {"name": "timestamp", "type": "TIMESTAMP", "mode": "REQUIRED"}
  ]
  EOF
}

# 3. Otorgar permisos al agente de servicio de Pub/Sub para escribir en BigQuery
resource "google_project_iam_member" "pubsub_bq_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_project_service_identity.pubsub_agent.email}"
}

resource "google_project_iam_member" "pubsub_bq_viewer" {
  project = var.project_id
  role    = "roles/bigquery.metadataViewer"
  member  = "serviceAccount:${google_project_service_identity.pubsub_agent.email}"
}

# 4. Tópico de Pub/Sub
resource "google_pubsub_topic" "realtime_topic" {
  name = var.topic_name
}

# 5. Suscripción de Pub/Sub con destino directo a BigQuery
resource "google_pubsub_subscription" "realtime_bq_sub" {
  name  = "realtime-bq-sub"
  topic = google_pubsub_topic.realtime_topic.id

  # Configuración para ingesta directa de Pub/Sub a BigQuery
  bigquery_config {
    # Se recomienda usar la nomenclatura de puntos para separar el proyecto
    table               = "${var.project_id}.${google_bigquery_table.realtime_events.dataset_id}.${google_bigquery_table.realtime_events.table_id}"
    use_table_schema    = true  # Utiliza el esquema de la tabla de BigQuery para mapear el JSON de entrada
    use_topic_schema    = false 
    drop_unknown_fields = true  # Descarta campos no declarados en el esquema de la tabla para evitar que la suscripción se detenga
    write_metadata      = false # Desactivamos columnas extras de metadatos de Pub/Sub
  }

  # Nos aseguramos de que los permisos IAM se hayan aplicado antes de crear la suscripción
  depends_on = [
    google_project_iam_member.pubsub_bq_editor,
    google_project_iam_member.pubsub_bq_viewer
  ]
}