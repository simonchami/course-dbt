{{
  config(
    materialized='table'
  )
}}


with int_orders as (
    select * from {{ ref('int_orders') }}
),

stg_postgres_users as (
        select * from {{ ref('stg_postgres_users') }}
)

select
    stg_postgres_users.user_id as user_id,
    count(distinct(int_orders.order_id)) as number_of_orders,
    sum(case
            when int_orders.has_promo = true then 1
            else 0 end) as number_of_promo_orders,
    sum(case 
            when order_status = 'delivered' then 1
            else 0 end) as number_of_delivered_orders,
    sum(case 
            when int_orders.delivered_within_estimated_date = true then 1
            else 0 end) as number_of_orders_delivered_in_time,
    avg(int_orders.days_to_deliver) as avg_days_to_deliver,
    sum(int_orders.order_total) as total_order_cost,
    sum(int_orders.shipping_cost) as total_shipping_cost
from stg_postgres_users
left join int_orders
on stg_postgres_users.user_id = int_orders.user_id
group by 1