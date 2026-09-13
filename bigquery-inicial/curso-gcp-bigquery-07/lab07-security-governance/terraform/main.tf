# 1. Habilitar APIs necesarias
resource "google_project_service" "datacatalog_api" {
  service            = "datacatalog.googleapis.com"
  disable_on_destroy = false
}

# 2. Cuenta de servicio para simular el rol analista de Europa
resource "google_service_account" "eu_analyst" {
  account_id   = "eu-analyst"
  display_name = "EU Data Analyst"
}

# Otorgar acceso de lectura general de BigQuery a la cuenta de servicio
resource "google_project_iam_member" "bq_viewer" {
  project = var.project_id
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${google_service_account.eu_analyst.email}"
}

resource "google_project_iam_member" "bq_data_viewer" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_service_account.eu_analyst.email}"
}

# 3. Dataset de BigQuery
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Lab 07 Dataset"
  description                 = "Dataset para pruebas de Seguridad y Gobernanza"
  location                    = "US"
  default_table_expiration_ms = 360000000 # 1 hora
}

# 4. Taxonomía y Etiquetas de Política de Data Catalog (Seguridad de Columna)
resource "google_data_catalog_taxonomy" "security_taxonomy" {
  depends_on             = [google_project_service.datacatalog_api]
  display_name           = "Taxonomia de Seguridad Lab 07"
  description            = "Clasificacion de datos PII y confidenciales"
  region                 = "us"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
}

resource "google_data_catalog_policy_tag" "pii_sensitive" {
  taxonomy     = google_data_catalog_taxonomy.security_taxonomy.id
  display_name = "PII Altamente Sensible"
  description  = "Etiqueta para datos como SSN o contraseñas"
}

# 5. Crear Tabla con Columna Protegida por la Etiqueta de Política
resource "google_bigquery_table" "employee_data" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "employee_data"

  schema = <<EOF
  [
    {"name": "emp_id", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "name", "type": "STRING", "mode": "REQUIRED"},
    {"name": "email", "type": "STRING", "mode": "NULLABLE"},
    {
      "name": "ssn", 
      "type": "STRING", 
      "mode": "REQUIRED",
      "policyTags": {
        "names": ["${google_data_catalog_policy_tag.pii_sensitive.id}"]
      }
    },
    {"name": "salary", "type": "FLOAT", "mode": "NULLABLE"},
    {"name": "region", "type": "STRING", "mode": "REQUIRED"}
  ]
  EOF
}

# 6. Seguridad a nivel de Fila: Filtro para el analista de Europa
resource "google_bigquery_row_access_policy" "eu_analyst_policy" {
  dataset_id       = google_bigquery_dataset.dataset.dataset_id
  table_id         = google_bigquery_table.employee_data.table_id
  policy_id        = "eu_only_filter"
  filter_predicate = "region = 'EU'"
  grantees         = ["serviceAccount:${google_service_account.eu_analyst.email}"]
}

# 7. Seguridad a nivel de Fila: Filtro para el Administrador (acceso completo)
resource "google_bigquery_row_access_policy" "admin_policy" {
  dataset_id       = google_bigquery_dataset.dataset.dataset_id
  table_id         = google_bigquery_table.employee_data.table_id
  policy_id        = "admin_all_access"
  filter_predicate = "true" # Permite ver todas las filas
  grantees         = ["user:${var.owner_email}"]
}