with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

order_totals as (
    select
        order_id,
        sum(quantity) as total_items,
        sum(line_total) as order_total
    from order_items
    group by order_id
)

select
    orders.order_id,
    orders.order_date,
    orders.status,
    customers.customer_id,
    customers.full_name as customer_name,
    customers.email as customer_email,
    order_totals.total_items,
    order_totals.order_total
from orders
left join customers on orders.customer_id = customers.customer_id
left join order_totals on orders.order_id = order_totals.order_id
