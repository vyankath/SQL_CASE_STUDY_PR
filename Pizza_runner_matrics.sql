-- Pizza Metrics
SELECT * FROM customer_orders_final;
SELECT * FROM runner_orders_final;
SELECT * FROM pizza_names;
SELECT * FROM pizza_recipes;
SELECT * FROM pizza_toppings;
SELECT * FROM runners;

-- 1. How many pizzas were ordered?
SELECT COUNT(order_id) AS ordered_pizzas FROM customer_orders_final;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_ordered_pizzas FROM customer_orders_final;

-- 3.How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS delivered FROM runner_orders_final
WHERE distance != 0 OR distance != NULL
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT p.pizza_name,COUNT(c.order_id) AS delivered FROM pizza_names p
JOIN customer_orders_final c ON p.pizza_id = c.pizza_id
JOIN runner_orders_final r on c.order_id = r.order_id
WHERE r.distance != 0 or r.distance != null
group by p.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT p.pizza_name,c.customer_id,COUNT(c.order_id) AS delivered FROM pizza_names p
JOIN customer_orders_final c ON p.pizza_id = c.pizza_id
JOIN runner_orders_final r on c.order_id = r.order_id
WHERE r.distance != 0 or r.distance != null
group by p.pizza_name,c.customer_id
ORDER BY c.customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT c.order_id, count(c.pizza_id) AS pizza_count FROM customer_orders_final c
JOIN runner_orders_final r ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.order_id
ORDER BY pizza_count DESC
LIMIT 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
WITH STATUS_TBL AS (SELECT order_id,customer_id,pizza_id,exclusions,extras,
                                                      CASE WHEN exclusions <> ' ' OR extras <> ' ' THEN 'Change' ELSE 'No_Change' END AS Status
FROM customer_orders_final)
SELECT customer_id,
       STATUS, 
       COUNT(STATUS) as count
FROM STATUS_TBL as s 
RIGHT JOIN runner_orders_final as r ON s.order_id = r.order_id
WHERE r.distance != 0
GROUP BY customer_id,STATUS
ORDER BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(c.order_id) AS order_count FROM customer_orders_final c 
JOIN runner_orders_final r ON c.order_id = r.order_id
WHERE r.distance != 0 AND exclusions <> ' ' AND extras <> ' ' AND r.cancellation <> ' '
ORDER BY c.order_id;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_time) AS day_of_pickup, COUNT(order_id) AS count_pizza
FROM customer_orders_final
WHERE HOUR(order_time) is not null
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);

-- 10. What was the volume of orders for each day of the week?
SELECT DAYNAME(order_time) AS day_of_pickup, COUNT(order_id) AS count_pizza
FROM customer_orders_final
WHERE DAYNAME(order_time) is not null
GROUP BY DAYNAME(order_time);