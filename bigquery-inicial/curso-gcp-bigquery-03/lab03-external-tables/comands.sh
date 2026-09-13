gcloud storage cp ../data/web_logs.csv gs://curso-gcp-bigquery-bq-external-tables-bucket/raw/logs/web_logs.csv

bq query --use_legacy_sql=false < sql/03_query_external_table.sql