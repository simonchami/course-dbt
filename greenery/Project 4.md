Products snapshot:

Due to a late submission of project 3, I don't see new changes on the data this week

This is the overall change from start to end of each product's inventory:
All products still have stock, with String of pearls being the product with less inventory. ZZ Plant and String of pearls were the ones with the biggest inventory drop (-48), followed by Monstera (-46). Not a single product saw its inventory rising.


NAME	PRICE	INITIAL_INVENTORY	FINAL_INVENTORY	INVENTORY_CHANGE
ZZ Plant	25	89	41	-48
String of pearls	80.5	58	10	-48
Monstera	50.75	77	31	-46
Bamboo	15.25	56	23	-33
Philodendron	45	51	30	-21
Pothos	30.5	40	20	-20
Majesty Palm	70	74	74	0
Spider Plant	15	67	67	0
Snake Plant	25.5	48	48	0
Rubber Plant	20.5	92	92	0
Ponytail Palm	80.75	93	93	0
Pink Anthurium	60.95	95	95	0
Pilea Peperomioides	20.5	85	85	0
Peace Lily	60.5	99	99	0
Orchid	50.75	58	58	0
Money Tree	30.5	59	59	0
Alocasia Polly	95	83	83	0
Jade Plant	15	94	94	0
Fiddle Leaf Fig	85.5	82	82	0
Ficus	20.25	44	44	0
Dragon Tree	50.25	73	73	0
Devil's Ivy	15.25	88	88	0
Calathea Makoyana	40.25	94	94	0
Cactus	15	81	81	0
Boston Fern	20	77	77	0
Birds Nest Fern	15.5	49	49	0
Bird of Paradise	65	97	97	0
Arrow Head	30.95	100	100	0
Angel Wings Begonia	95	65	65	0
Aloe Vera	15	47	47	0

SQL:

with snapshots as (
select name, price, inventory, row_number() over (partition by name order by dbt_valid_from asc) as snapshot_number from dev_db.dbt_simonchamimolliecom.products_snapshot
order by name),

number_of_snapshots as (
select name, max(snapshot_number) as number_of_snapshots from snapshots
group by 1
),

initial_inventory as (
select name, price, inventory as initial_inventory from snapshots
where snapshot_number = 1),

final_inventory as (
select snapshots.name, price, inventory as final_inventory from snapshots
left join number_of_snapshots
on snapshots.name = number_of_snapshots.name
where snapshot_number = number_of_snapshots
)

select initial_inventory.name as name, initial_inventory.price as price, initial_inventory, final_inventory, final_inventory - initial_inventory as inventory_change 
from initial_inventory
left join final_inventory
on initial_inventory.name = final_inventory.name
order by inventory_change asc


Part 2

Total Conversion rates:

NUMBER_OF_PAGE_VIEWS: 14,741
NUMBER_OF_ADD_TO_CART: 8,650
NUMBER_OF_CHECKOUT:	8,209
ADD_TO_CART_CONVERSION: 0.586799	
CHECKOUT_CONVERSION: 0.347168	
PAGE_VIEW_TO_CHECKOUT_CONVERSION: 0.557
			
SQL:
with totals as(
    select 
        sum(page_views) as number_of_page_views,
        sum(add_to_carts) as number_of_add_to_cart,
        sum(checkouts) as number_of_checkout
    from dev_db.dbt_simonchamimolliecom.fact_page_views
),

conversion_rates as(
select 
    (number_of_add_to_cart / number_of_page_views) as add_to_cart_conversion,
    (number_of_checkout / number_of_add_to_cart) as checkout_conversion,
    (number_of_checkout / number_of_page_views) as page_view_to_checkout_conversion
from totals
)

select * from totals
join conversion_rates

I've also created conversion measures per product, user and date, each one in a separate model

Overall conversion rate is above 55%, meaning that from all the page views 55% end up in a purchase.
Conversion from add to cart to checkout is pretty high, aroun 95%, meaning that almost all products that make it to cart end up being purchased.
The biggest drop in the funnel occurs in the add to cart, where only 59% of the viewed products end up being added to cart.

Part 3

My organization already uses dbt as the modelling layer for analytics. All data from production sources is modelled in dbt before being ingested by Looker, which is our BI tool. Also, analytics tables can be accessed from Bigquery after the dbt layer. For me it is very useful because I can search for any code in the dbt repo and find out the logic behind the data I need to use for analysis. All is very well documented and easy to access. The data is separated in different folders to account for ownership of the different teams.

We also use macros to generate events models, but no so much to improve basic SQL queries, like using dbt utils or for loops inside the queries, which is something that we could think of improving.

We could also think about moving a lot of the modelling that we do in Looker to dbt, since it's way more efficient and ready to access from anywhere, including for example python notebooks.