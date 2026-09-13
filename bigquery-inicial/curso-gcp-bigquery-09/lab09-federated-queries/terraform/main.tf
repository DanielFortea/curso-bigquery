# 1. Dataset de BigQuery
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Lab 09 Dataset"
  description                 = "Dataset para pruebas de Consultas Federadas con Cloud SQL"
  location                    = "US"
  default_table_expiration_ms = 3600000 # 1 hora
}

# 2. Instancia de Cloud SQL PostgreSQL (compartida de bajo coste para laboratorio)
resource "google_sql_database_instance" "postgres_instance" {
  name             = "postgres-lab09-instance"
  database_version = "POSTGRES_15"
  region           = var.region
  deletion_protection = false # Permite borrar la base de datos limpiamente con 'terraform destroy'

  settings {
    tier = "db-f1-micro"
    
    ip_configuration {
      ipv4_enabled = true
      
      # ADVERTENCIA: Permite conexiones desde cualquier IP solo para facilitar el seeding local en este laboratorio.
      # No aplicar en entornos de producción.
      authorized_networks {
        name  = "all-networks"
        value = "0.0.0.0/0"
      }
    }
  }
}

# 3. Base de datos operativa
resource "google_sql_database" "postgres_db" {
  name     = "operational_db"
  instance = google_sql_database_instance.postgres_instance.name
}

# 4. Usuario de la base de datos
resource "google_sql_user" "postgres_user" {
  name     = "bq_user"
  instance = google_sql_database_instance.postgres_instance.name
  password = "SecurePassword123!"
}

# 5. Recurso de Conexión de BigQuery a Cloud SQL
resource "google_bigquery_connection" "postgres_connection" {
  connection_id = "postgres-conn"
  location      = "US" # Debe coincidir con la ubicación multi-región del dataset de BigQuery
  friendly_name = "Cloud SQL Postgres Connection"

  cloud_sql {
    instance_id = google_sql_database_instance.postgres_instance.connection_name
    database    = google_sql_database.postgres_db.name
    type        = "POSTGRES"
    
    credential {
      username = google_sql_user.postgres_user.name
      password = google_sql_user.postgres_user.password
    }
  }
}

# 6. Permisos IAM: Autorizar a la cuenta de servicio de la conexión a leer Cloud SQL
resource "google_project_iam_member" "connection_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_bigquery_connection.postgres_connection.cloud_sql[0].service_account_id}"
}

# 7. Tabla nativa de BigQuery (datos de comportamiento que uniremos con Cloud SQL)
resource "google_bigquery_table" "order_summaries" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "order_summaries"

  schema = <<EOF
  [
    {"name": "customer_id", "type": "STRING", "mode": "REQUIRED"},
    {"name": "total_orders", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "total_spent", "type": "FLOAT", "mode": "REQUIRED"}
  ]
  EOF
}