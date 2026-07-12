with source as (
    select * from {{ ref('raw_orders') }}
)

select
    order_id,
    customer_id,
    order_date::date as order_date,
    lower(status) as status
from source
