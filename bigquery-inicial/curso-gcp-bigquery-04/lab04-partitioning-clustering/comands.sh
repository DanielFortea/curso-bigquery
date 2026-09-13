bq load \
  --source_format=CSV \
  --skip_leading_rows=1 \
  lab04_dataset.transactions_optimized \
  ../data/transactions.csv