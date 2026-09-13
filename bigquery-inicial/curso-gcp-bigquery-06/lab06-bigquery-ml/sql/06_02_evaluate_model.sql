-- Evaluar las métricas de rendimiento del modelo (R2, MAE, MSE)
SELECT
  *
FROM
  ML.EVALUATE(MODEL `lab06_dataset.spend_predictor_model`);