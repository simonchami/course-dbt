{{
  config(
    materialized='table'
  )
}}


with stg_postgres_events as (
  select * from {{ ref('stg_postgres_events') }}
),

stg_order_items as (
    select * from {{ ref('stg_postgres_order_items') }}
),

fact_product_funnel_session as (
  select
    stg_postgres_events.session_id  as session_id,
    coalesce(stg_postgres_events.product_id, stg_postgres_order_items.product_id) as product_id,
    sum(case when event_type = 'page_view' then 1 else 0 end) as number_of_page_views,
    sum(case when event_type = 'add_to_cart' then 1 else 0 end) as number_of_add_to_cart,
    sum(case when event_type = 'checkout' then 1 else 0 end) as number_of_checkout,
    sum(case when event_type = 'package_shipped' then 1 else 0 end) as number_of_packages_shipped
  from stg_postgres_events
  left join int_events 
  on stg_postgres_events.session_id = int_events.session_id
  left join stg_postgres_order_items
  on stg_postgres_events.order_id = stg_postgres_order_items.order_id
  group by 1,2)


select 
  session_id,
  product_id,
  number_of_page_views,
  number_of_add_to_cart,
  number_of_checkout,
  number_of_packages_shipped
from fact_product_funnel_session
