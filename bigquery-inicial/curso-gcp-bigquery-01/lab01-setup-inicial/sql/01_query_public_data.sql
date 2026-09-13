-- Consulta para analizar los nombres de bebés más populares en el estado de Nueva York
-- y guardar los resultados como una nueva tabla en nuestro dataset del laboratorio 1.

CREATE OR REPLACE TABLE `lab01_dataset.popular_ny_names` AS
SELECT
  name,
  gender,
  SUM(number) AS total_count
FROM
  `bigquery-public-data.usa_names.usa_1910_current`
WHERE
  state = 'NY'
GROUP BY
  name,
  gender
ORDER BY
  total_count DESC
LIMIT 100;