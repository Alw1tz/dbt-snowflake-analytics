with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('int_orders_enriched') }}
    where status = 'completed'
),

customer_orders as (
    select
        customer_id,
        count(distinct order_id) as completed_orders,
        sum(order_total) as lifetime_value,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date
    from orders
    group by customer_id
)

select
    customers.customer_id,
    customers.full_name,
    customers.email,
    customers.signup_date,
    coalesce(customer_orders.completed_orders, 0) as completed_orders,
    coalesce(customer_orders.lifetime_value, 0) as lifetime_value,
    customer_orders.first_order_date,
    customer_orders.most_recent_order_date
from customers
left join customer_orders on customers.customer_id = customer_orders.customer_id
