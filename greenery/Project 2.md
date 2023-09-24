Part 1.

What is our user repeat rate?

The repeat rate is 79.8%

SQL: 
with users as (select 
count(distinct user_id) as total_number_of_users,
count(distinct (case when number_of_orders > 0 then user_id else null end)) as number_of_users_who_purchased,
count(distinct (case when number_of_orders > 1 then user_id else null end)) as number_of_users_who_repeated
from dev_db.dbt_simonchamimolliecom.fact_order_users)

select number_of_users_who_repeated / number_of_users_who_purchased as repeat_rate from users

What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

One good indicator could be users that didn't receive their orders within the estimated delivery time, or users that never received any promo

Explain the product mart models you added. Why did you organize the models in the way you did?

I created a fact_order_users model that inidcates how many orders each user made, how many were delivered, average days to delivery, total revenue per user, etc. Another model to see the outome of each session by user to analyze conversion differences.


Part 2.

I added unique and not_null tests for all primary keys to avoid any errors on tha data ingestion process.

Part 3.


NAME	          INVENTORY	OLD_INVENTORY	INVENTORY_CHANGE
Philodendron	  25	        51	            -26
String of pearls  10	        58	            -48
Monstera	      64	        77	            -13
Pothos	          20	        40	            -20