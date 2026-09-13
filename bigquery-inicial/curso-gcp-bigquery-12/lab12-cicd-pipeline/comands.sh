gcloud storage buckets create gs://curso-gcp-bigquery-tfstate --location=US

gcloud iam service-accounts create bq-cicd-sa --display-name="BigQuery CI-CD Service Account"

gcloud projects add-iam-policy-binding curso-gcp-bigquery \
  --member="serviceAccount:bq-cicd-sa@curso-gcp-bigquery.iam.gserviceaccount.com" \
  --role="roles/bigquery.admin"

gcloud projects add-iam-policy-binding curso-gcp-bigquery \
  --member="serviceAccount:bq-cicd-sa@curso-gcp-bigquery.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud iam service-accounts keys create sa-key.json --iam-account=bq-cicd-sa@curso-gcp-bigquery.iam.gserviceaccount.com