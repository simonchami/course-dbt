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

{% set event_types = dbt_utils.get_column_values(
  table=ref('stg_postgres_events'),
        column='event_type'
) %}

fact_page_views as (
  select
    int_events.session_id as session_id,
    int_events.user_id as user_id,
    min(int_events.created_at)  as session_created_at,
    max(int_events.created_at) as session_ended_at,
    {% for event_type in event_types %}
    {{ sum_of('event_type', event_type)}} as {{ event_type }}s,
    {% endfor %}
    max(event_type_code) as session_final_outcome_code
  from int_events
  left join stg_postgres_events 
  on int_events.session_id = stg_postgres_events.session_id
  group by 1, 2)


select 
  *,
  case 
    when session_final_outcome_code = 1 then 'page_view'
    when session_final_outcome_code = 2 then 'add_to_cart'
    when session_final_outcome_code = 3 then 'checkout'
    when session_final_outcome_code = 4 then 'package_shipped'
    else null end as session_final_outcome
from fact_page_views
