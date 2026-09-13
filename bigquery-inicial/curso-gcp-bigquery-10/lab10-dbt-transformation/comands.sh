bq query --use_legacy_sql=false \
  "INSERT INTO \`lab10_raw.raw_orders\` (order_id, customer_id, order_date, amount, status) VALUES
  (1, 'C101', '2026-03-01', 120.50, 'completed'),
  (2, 'C102', '2026-03-01', 45.00, 'completed'),
  (3, 'C101', '2026-03-02', -10.00, 'returned'),
  (4, 'C103', '2026-03-02', 15.90, 'completed'),
  (5, 'C102', '2026-03-02', 60.00, 'pending'),
  (6, 'C101', '2026-03-03', 210.00, 'completed');"

mkdir dbt_project && cd dbt_project
python3 -m venv venv
source venv/bin/activate
pip install dbt-bigquery

mkdir -p models/staging models/marts tests
gcloud auth application-default login
dbt run
dbt test