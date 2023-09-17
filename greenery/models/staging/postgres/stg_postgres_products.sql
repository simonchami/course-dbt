select
    product_id,
    name AS product_name,
    price,
    inventory
from {{ source('postgres', 'products')}}