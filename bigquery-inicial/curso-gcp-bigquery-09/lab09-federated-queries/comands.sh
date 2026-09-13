gcloud sql instances describe postgres-lab09-instance --format="value(ipAddresses.ipAddress)"

psql "sslmode=disable host=34.134.30.87 dbname=operational_db user=bq_user"

bq query --use_legacy_sql=false \
  "INSERT INTO \`lab09_dataset.order_summaries\` (customer_id, total_orders, total_spent) VALUES
  ('C101', 5, 350.50),
  ('C102', 12, 780.00),
  ('C103', 2, 120.00),
  ('C104', 20, 1100.20);"

bq query --use_legacy_sql=false < sql/09_02_federated_join.sql