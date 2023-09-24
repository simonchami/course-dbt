{{
  config(
    materialized='table'
  )
}}


with int_events as (
    select * from {{ ref('int_events') }}
),

stg_postgres_events as (
  select * from {{ ref('stg_postgres_events') }}
),

fact_page_views as (
  select
    int_events.session_id as session_id,
    int_events.user_id as user_id,
    min(int_events.created_at)  as session_created_at,
    max(int_events.created_at) as session_ended_at,
    sum(case when event_type = 'page_view' then 1 else 0 end) as number_of_page_views,
    sum(case when event_type = 'add_to_cart' then 1 else 0 end) as number_of_add_to_cart,
    sum(case when event_type = 'checkout' then 1 else 0 end) as number_of_checkout,
    sum(case when event_type = 'package_shipped' then 1 else 0 end) as number_of_packages_shipped,
    max(event_type_code) as session_final_outcome
  from int_events
  left join stg_postgres_events 
  on int_events.session_id = stg_postgres_events.session_id
  group by 1, 2)


select 
  session_id,
  user_id,
  session_created_at,
  session_ended_at,
  number_of_page_views,
  number_of_add_to_cart,
  number_of_checkout,
  number_of_packages_shipped,
  case 
    when session_final_outcome = 1 then 'page_view'
    when session_final_outcome = 2 then 'add_to_cart'
    when session_final_outcome = 3 then 'checkout'
    when session_final_outcome = 4 then 'package_shipped'
    else null end as session_final_outcome
from fact_page_views
