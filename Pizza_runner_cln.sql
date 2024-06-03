USE pizza_runner;
CREATE TABLE runner_orders_final AS
SELECT 
  order_id, 
  runner_id,  
  CASE
	  WHEN pickup_time LIKE 'null' THEN NULL
	  ELSE pickup_time
	  END AS pickup_time,
  CASE
	  WHEN distance LIKE 'null' THEN NULL
	  WHEN distance LIKE '%km' THEN TRIM('km' from distance)
	  ELSE distance 
    END AS distance,
  CASE
	  WHEN duration LIKE 'null' THEN NULL
	  WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
	  WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
	  WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
	  ELSE duration
	  END AS duration,
  CASE
	  WHEN cancellation IS NULL or cancellation LIKE 'null' THEN NULL
      WHEN cancellation = '' THEN NULL
	  ELSE cancellation
	  END AS n_cancellation
FROM runner_orders;

CREATE TABLE customer_orders_final AS
select order_id, customer_id, pizza_id, order_time,
case when exclusions = '' then null
when exclusions = 'null' then null
else exclusions end as exclusions_cleaned,
case when extras = '' then null
when extras = 'null' then null
else extras end as extras_cleaned
from customer_orders;
       