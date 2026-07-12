with orders as (
    select * from {{ ref('int_orders_enriched') }}
    where status = 'completed'
)

select
    order_date,
    count(distinct order_id) as orders_count,
    count(distinct customer_id) as unique_customers,
    sum(total_items) as items_sold,
    sum(order_total) as revenue,
    round(sum(order_total) / nullif(count(distinct order_id), 0), 2) as avg_order_value
from orders
group by order_date
order by order_date
