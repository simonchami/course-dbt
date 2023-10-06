Conversion rate:

select 
count(case when session_final_outcome IN ('checkout', 'package_shipped') then session_id else null end) / (count(session_id)) as conversion_rate from dev_db.dbt_simonchamimolliecom.fact_page_views

The overall conversion rate is 62.5%

By product: 

with conversion_rates as (
    select 
        product_id, 
        count(distinct(case when number_of_checkout > 0 then session_id else null end))/(count(distinct(session_id))) as conversion_rate
    from dev_db.dbt_simonchamimolliecom.fact_product_funnel_session
    group by 1
)

select 
    product_name, 
    conversion_rate
from conversion_rates
left join dev_db.dbt_simonchamimolliecom.stg_postgres_products as products
on conversion_rates.product_id = products.product_id
order by 2 desc


PRODUCT_NAME	CONVERSION_RATE
String of pearls	0.609375
Arrow Head	0.555556
Cactus	0.545455
ZZ Plant	0.539683
Bamboo	0.537313
Rubber Plant	0.518519
Monstera	0.510204
Calathea Makoyana	0.509434
Fiddle Leaf Fig	0.500000
Majesty Palm	0.492537
Aloe Vera	0.492308
Devil's Ivy	0.488889
Philodendron	0.483871
Jade Plant	0.478261
Pilea Peperomioides	0.474576
Spider Plant	0.474576
Dragon Tree	0.467742
Money Tree	0.464286
Orchid	0.453333
Bird of Paradise	0.450000
Ficus	0.426471
Birds Nest Fern	0.423077
Pink Anthurium	0.418919
Boston Fern	0.412698
Alocasia Polly	0.411765
Peace Lily	0.409091
Ponytail Palm	0.400000
Snake Plant	0.397260
Angel Wings Begonia	0.393443
Pothos	0.344262


Product snapshot

with previous_inventory as (
select * from dev_db.dbt_simonchamimolliecom.products_snapshot
where dbt_valid_to = '2023-10-06 17:00:09.060'),

actual_inventory as (
select * from dev_db.dbt_simonchamimolliecom.products_snapshot
where dbt_updated_at = '2023-10-06 17:00:09.060')

select
previous_inventory.name as product_name,
previous_inventory.inventory as previous_inventory,
actual_inventory.inventory as actual_inventory,
actual_inventory.inventory - previous_inventory.inventory as inventory_change
from
previous_inventory
left join actual_inventory
on previous_inventory.product_id = actual_inventory.product_id

PRODUCT_NAME	PREVIOUS_INVENTORY	ACTUAL_INVENTORY	INVENTORY_CHANGE
Philodendron	25	30	5
Monstera	64	31	-33
Bamboo	56	23	-33
ZZ Plant	89	41	-48