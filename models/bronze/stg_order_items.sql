with source as (
    select * from {{ ref('raw_order_items') }}
)

select
    order_item_id,
    order_id,
    product_name,
    quantity,
    unit_price::decimal(10, 2) as unit_price,
    (quantity * unit_price)::decimal(10, 2) as line_total
from source
