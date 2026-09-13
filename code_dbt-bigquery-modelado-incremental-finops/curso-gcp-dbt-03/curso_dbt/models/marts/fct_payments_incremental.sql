{{
    config(
        materialized='incremental',
        unique_key='payment_id'
    )
}}

select *
from {{ ref('stg_payments') }}

{% if is_incremental() %}
  where payment_id not in (select payment_id from {{ this }})
{% endif %}