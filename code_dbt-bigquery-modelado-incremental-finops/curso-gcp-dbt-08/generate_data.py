import pandas as pd
from faker import Faker
import random
from google.cloud import bigquery
from datetime import datetime, timedelta

project_id = 'curso-gcp-dbt'
dataset_id = 'raw_ecommerce'
client = bigquery.Client(project=project_id)
fake = Faker()

# 1. Generar Customers
num_customers = 500
customers =[{'customer_id': i, 'first_name': fake.first_name(), 'last_name': fake.last_name(), 
              'email': fake.email(), 'country': fake.country()} for i in range(1, num_customers + 1)]
df_customers = pd.DataFrame(customers)

# 2. Generar Orders
orders = []
order_statuses =['placed', 'shipped', 'completed', 'returned']
for i in range(1, 2001):
    orders.append({
        'order_id': i,
        'customer_id': random.randint(1, num_customers),
        'order_date': fake.date_between(start_date='-1y', end_date='today').strftime('%Y-%m-%d'),
        'status': random.choices(order_statuses, weights=[10, 20, 60, 10])[0]
    })
df_orders = pd.DataFrame(orders)

# 3. Generar Payments
payments =[]
for order in orders:
    # 1 o 2 pagos por pedido
    for _ in range(random.randint(1, 2)):
        payments.append({
            'payment_id': fake.uuid4(),
            'order_id': order['order_id'],
            'payment_method': random.choice(['credit_card', 'paypal', 'bank_transfer', 'crypto']),
            'amount_cents': random.randint(1000, 50000) # Céntimos
        })
df_payments = pd.DataFrame(payments)

# Cargar a BigQuery
def load_to_bq(df, table_name):
    table_id = f"{project_id}.{dataset_id}.{table_name}"
    job = client.load_table_from_dataframe(df, table_id)
    job.result()
    print(f"Cargados {len(df)} registros en {table_id}")

load_to_bq(df_customers, 'customers')
load_to_bq(df_orders, 'orders')
load_to_bq(df_payments, 'payments')