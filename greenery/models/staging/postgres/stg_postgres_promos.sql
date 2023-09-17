select
    promo_id,
    discount,
    status AS promo_status
from {{ source('postgres', 'promos')}}