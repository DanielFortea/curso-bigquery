WITH staging AS (
    SELECT * FROM {{ ref('stg_raw_orders') }}
)

SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) AS total_revenue,
    SUM(CASE WHEN status = 'returned' THEN amount ELSE 0 END) AS total_returned_amount
FROM staging
GROUP BY customer_id