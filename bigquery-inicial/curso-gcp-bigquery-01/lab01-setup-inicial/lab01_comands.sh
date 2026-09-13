gcloud services enable cloudresourcemanager.googleapis.com bigquery.googleapis.com

bq query --use_legacy_sql=false 'SELECT * FROM `lab01_dataset.popular_ny_names` LIMIT 10;'