with source as (
    select 
        id, 
        first_name, 
        last_name 
    from {{ ref('raw_customers') }}
),

renamed as (
    select
        id as customer_id,
        first_name,
        last_name
    from source
)

select * 
from renamed
