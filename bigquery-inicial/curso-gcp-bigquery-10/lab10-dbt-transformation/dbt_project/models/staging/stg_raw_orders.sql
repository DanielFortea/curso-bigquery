WITH source AS (
    SELECT * FROM {{ source('lab10_raw', 'raw_orders') }}
)

SELECT
    order_id,
    customer_id,
    PARSE_DATE('%Y-%m-%d', order_date) AS order_date,
    amount,
    COALESCE(status, 'unknown') AS status
FROM source