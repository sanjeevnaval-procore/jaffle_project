select distinct customer_id from {{ source('mart_source', 'customers') }} 
UNION ALL
select distinct order_id from {{ source('mart_source', 'orders') }} 