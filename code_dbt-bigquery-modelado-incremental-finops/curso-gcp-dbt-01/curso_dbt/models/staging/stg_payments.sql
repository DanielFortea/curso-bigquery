select
    payment_id,
    order_id,
    payment_method,
    {{ cents_to_dollars('amount_cents') }} as amount_usd
from {{ source('ecommerce', 'payments') }}