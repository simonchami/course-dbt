{{
  config(
    materialized='table'
  )
}}

with stg_postgres_orders as (
    select * from {{ ref('stg_postgres_orders') }}
)

select
    order_id,
    promo_id,
    user_id,
    address_id,
    created_at,
    order_cost,
    shipping_cost,
    order_total,
    tracking_id,
    shipping_service,
    estimated_delivery_at,
    delivered_at,
    DATEDIFF(day, created_at, delivered_at ) AS days_to_deliver,
    case 
        when order_status = 'delivered' and delivered_at <= estimated_delivery_at then true
        when order_status = 'delivered' and delivered_at > estimated_delivery_at then false
        else null 
    end as delivered_within_estimated_date,
    case 
        when promo_id is not null then true
        else false 
    end as has_promo,
    order_status
from stg_postgres_orders