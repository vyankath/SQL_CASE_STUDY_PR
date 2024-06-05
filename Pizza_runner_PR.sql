    -- D. Pricing and Ratings

SELECT * FROM customer_orders_final;
SELECT * FROM runner_orders_final;
SELECT * FROM pizza_names;
SELECT * FROM pizza_recipes;
SELECT * FROM pizza_toppings;
SELECT * FROM runners;

-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
SELECT  SUM(pizza_cost) AS total_cost
FROM (SELECT r.runner_id,
      CASE WHEN c.pizza_id = 1 THEN 12
		   WHEN c.pizza_id = 2 THEN 10 END AS pizza_cost
       FROM customer_orders_final c
       JOIN runner_orders_final r ON c.order_id = r.order_id
       WHERE r.n_cancellation IS NULL) AS pizza_cost_per_run


-- 2. What if there was an additional $1 charge for any pizza extras?
      -- Add cheese is $1 extra
SELECT SUM(total_cost) AS total_cost
FROM (SELECT r.runner_id,
      CASE WHEN c.pizza_id = 1 THEN 12 
	       WHEN c.pizza_id = 2 THEN 10 END + 
      CASE WHEN c.extras LIKE '%4%' THEN 1 ELSE 0 END +
      CASE WHEN c.extras IS NOT NULL  THEN 1 ELSE 0 END AS total_cost
FROM customer_orders_final c
JOIN runner_orders_final r ON c.order_id = r.order_id
WHERE r.n_cancellation IS NULL) AS cost_per_run;

-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset
      -- generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
CREATE TABLE ratings (n_order_id INT , rating INT);
INSERT INTO ratings (n_order_id, rating) VALUES (1,3), (2,4), (3,5), (4,2),(5,1), (6,3), (7,4), (8,1), (9,3), (10,5);

-- 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
      -- customer_id
      -- order_id
      -- runner_id
      -- rating
      -- order_time
      -- pickup_time
      -- Time between order and pickup
      -- Delivery duration
      -- Average speed
      -- Total number of pizzas
SELECT c.customer_id, c.order_id, c.order_time, r.runner_id, r.duration, r.pickup_time, rs.rating,
       TIMESTAMPDIFF(MINUTE,c.order_time,r.pickup_time) AS order_pickup_time,
       ROUND(AVG(r.distance/(r.duration/60)),2) AS avg_speed,
       COUNT(c.pizza_id) AS total_pizza
FROM customer_orders_final c 
JOIN runner_orders_final r ON r.order_id = c.order_id
JOIN ratings rs ON c.order_id = rs.n_order_id
WHERE r.n_cancellation is NULL
GROUP BY c.customer_id, c.order_id, c.order_time, r.runner_id, r.duration, r.pickup_time, rs.rating
ORDER BY c.customer_id

-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
   -- how much money does Pizza Runner have left over after these deliveries?
SELECT runner_id,
       SUM(pizza_cost) AS total_revenue,
       SUM(distance) * 0.3 AS total_spend,
       SUM(pizza_cost) - SUM(distance) * 0.3 AS profit
FROM (SELECT r.runner_id, r.distance,
	  CASE WHEN c.pizza_id = 1 THEN 12
		   WHEN c.pizza_id = 2 THEN 10 END AS pizza_cost
       FROM customer_orders_final c
       JOIN runner_orders_final r ON c.order_id = r.order_id
       WHERE r.n_cancellation IS NULL) AS pizza_cost_per_run
GROUP BY runner_id;