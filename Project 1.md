How many users do we have?

We have 130 users

SQL: 
SELECT COUNT(user_id) FROM dev_db.dbt_simonchamimolliecom.stg_postgres_users

On average, how many orders do we receive per hour?

We recieve 7.52 orders per hour on average

SQL:
WITH orders_per_hour AS
(SELECT TO_CHAR(created_at, 'YYYY-MM-DD HH24'), COUNT(DISTINCT(order_id)) AS orders FROM dev_db.dbt_simonchamimolliecom.stg_postgres_orders
GROUP BY 1)

SELECT AVG(orders) FROM orders_per_hour

On average, how long does an order take from being placed to being delivered?

It takes 3.89 days on average

SQL:
SELECT AVG(TIMEDIFF(DAY , created_at , delivered_at)) FROM dev_db.dbt_simonchamimolliecom.stg_postgres_orders
WHERE delivered_at IS NOT NULL

How many users have only made one purchase? Two purchases? Three+ purchases?

First part SQL:
WITH orders_per_user AS (
SELECT user_id, COUNT(DISTINCT(order_id)) AS number_of_orders FROM dev_db.dbt_simonchamimolliecom.stg_postgres_orders
GROUP BY 1)
SELECT COUNT(DISTINCT (user_id)) AS number_of_users FROM orders_per_user
WHERE number_of_orders = 1

25 Users made 1 purchase

SELECT COUNT(DISTINCT (user_id)) AS number_of_users FROM orders_per_user
WHERE number_of_orders = 2

28 Users made 2 purchases

SELECT COUNT(DISTINCT (user_id)) AS number_of_users FROM orders_per_user
WHERE number_of_orders > 2

71 Users made three or more purchases

On average, how many unique sessions do we have per hour?

We have 16.33 sessions per hour on average

SQL:
WITH sessions_per_hour AS
(SELECT TO_CHAR(created_at, 'YYYY-MM-DD HH24'), COUNT(DISTINCT(session_id)) AS sessions FROM dev_db.dbt_simonchamimolliecom.stg_postgres_events
GROUP BY 1)

SELECT AVG(sessions) FROM sessions_per_hour
