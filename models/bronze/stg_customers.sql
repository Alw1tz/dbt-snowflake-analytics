with source as (
    select * from {{ ref('raw_customers') }}
)

select
    customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name,
    lower(email) as email,
    signup_date::date as signup_date
from source
