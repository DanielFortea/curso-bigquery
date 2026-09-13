-- 1. Definición de una función de usuario temporal (UDF) para segmentar ventas
CREATE TEMP FUNCTION CategorizeSale(amount FLOAT64) AS (
  CASE 
    WHEN amount >= 150.0 THEN 'High Value'
    WHEN amount >= 50.0 AND amount < 150.0 THEN 'Medium Value'
    ELSE 'Low Value'
  END
);

-- 2. Expresión de Tabla Común (CTE) para calcular métricas de secuencia por cliente
WITH sales_analysis AS (
  SELECT
    sale_id,
    customer_id,
    sale_date,
    amount,
    product_category,
    CategorizeSale(amount) AS sale_segment,
    
    -- Numerar correlativamente las compras de cada cliente según su orden temporal
    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY sale_date) AS purchase_sequence,
    
    -- Obtener el importe de la compra inmediatamente anterior para comparar tendencias
    LAG(amount, 1, 0.0) OVER(PARTITION BY customer_id ORDER BY sale_date) AS previous_sale_amount,
    
    -- Calcular la suma acumulada de gasto por cliente a lo largo del tiempo
    SUM(amount) OVER(
      PARTITION BY customer_id 
      ORDER BY sale_date 
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_spent
  FROM
    `lab05_dataset.ecommerce_sales`
)

-- 3. Selección y cálculo de variaciones porcentuales o absolutas de compras
SELECT
  customer_id,
  sale_date,
  amount,
  sale_segment,
  purchase_sequence,
  previous_sale_amount,
  (amount - previous_sale_amount) AS spend_difference,
  cumulative_spent
FROM
  sales_analysis
ORDER BY
  customer_id,
  purchase_sequence;