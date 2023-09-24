{{
  config(
    materialized='table'
  )
}}

with stg_postgres_events as (
    select * from {{ ref('stg_postgres_events') }}
)

select
    event_id,
    session_id,
    user_id,
    created_at,
    case
        when event_type = 'page_view' then 1
        when event_type = 'add_to_cart' then 2
        when event_type = 'checkout' then 3
        when event_type = 'package_shipped' then 4
    end as event_type_code
from stg_postgres_events
