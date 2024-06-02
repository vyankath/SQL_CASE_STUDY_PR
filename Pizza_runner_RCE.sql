-- Runner and Customer Experience
SELECT * FROM customer_orders_final;
SELECT * FROM runner_orders_final;
SELECT * FROM pizza_names;
SELECT * FROM pizza_recipes;
SELECT * FROM pizza_toppings;
SELECT * FROM runners;

-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT WEEK(registration_date) AS weekno, COUNT(runner_id) AS reg_runner FROM runners
GROUP BY WEEK(registration_date);

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH avg_del_time AS 
                    (SELECT r.runner_id, TIMESTAMPDIFF(MINUTE,c.order_time,r.pickup_time) AS del_time FROM customer_orders_final c
					 JOIN runner_orders_final r ON c.order_id = r.order_id
					 WHERE r.distance != 0 and n_cancellation is null)
SELECT runner_id, ROUND(AVG(del_time),2) AS del_avg_time FROM avg_del_time
GROUP BY runner_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

-- 4. What was the average distance travelled for each customer?
SELECT c.customer_id, ROUND(AVG(r.distance)) AS avg_dist FROM customer_orders_final c
JOIN runner_orders_final r on c.order_id = r.order_id 
GROUP BY c.customer_id;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT (MAX(duration) - MIN(duration)) AS diff_time FROM runner_orders_final;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT order_id,runner_id, ROUND(AVG(distance/(duration/60)),2) AS avg_speed FROM runner_orders_final
WHERE distance IS NOT NULL OR duration IS NOT NULL 
GROUP BY order_id,runner_id;

-- 7. What is the successful delivery percentage for each runner?
WITH succ_ord AS (SELECT runner_id, COUNT(order_id) AS delivered FROM runner_orders_final
                  WHERE distance != 0 OR distance != NULL
                  GROUP BY runner_id)
SELECT r.runner_id, (succ_ord.delivered/COUNT(*)*100) perc_deli FROM succ_ord 
JOIN runner_orders_final r ON succ_ord.runner_id = r.runner_id
GROUP BY r.runner_id;