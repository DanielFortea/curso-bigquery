-- Realizar una predicción para nuevos datos de clientes ficticios
SELECT
  predicted_yearly_spend,
  age,
  loyalty_years,
  total_previous_orders
FROM
  ML.PREDICT(
    MODEL `lab06_dataset.spend_predictor_model`,
    (
      SELECT 28 AS age, 2 AS loyalty_years, 6 AS total_previous_orders UNION ALL
      SELECT 38 AS age, 4 AS loyalty_years, 10 AS total_previous_orders
    )
  );