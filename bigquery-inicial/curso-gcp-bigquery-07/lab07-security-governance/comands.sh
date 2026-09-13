bq query --use_legacy_sql=false < sql/07_01_query_as_owner.sql

gcloud iam service-accounts keys create sa-key.json \
  --iam-account=eu-analyst@curso-gcp-bigquery.iam.gserviceaccount.com

gcloud auth activate-service-account --key-file=sa-key.json