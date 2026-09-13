-- Entrenar un modelo de regresión lineal para predecir 'yearly_spend'
CREATE OR REPLACE MODEL `lab06_dataset.spend_predictor_model`
OPTIONS(
  model_type='linear_reg',
  input_label_cols=['yearly_spend']
) AS
SELECT
  age,
  loyalty_years,
  total_previous_orders,
  yearly_spend
FROM
  `lab06_dataset.customer_features`;