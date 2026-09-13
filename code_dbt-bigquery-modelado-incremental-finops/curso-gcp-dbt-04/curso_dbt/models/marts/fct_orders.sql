with orders as (
    select * from {{ ref('stg_orders') }}
),
payments as (
    select * from {{ source('ecommerce', 'payments') }}
),
order_payments as (
    select
        order_id,
        sum(amount_cents) / 100.0 as total_amount
    from payments
    group by 1
)
select
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,
    coalesce(p.total_amount, 0) as amount
from orders o
left join order_payments p using (order_id)