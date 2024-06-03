-- C. Ingredient Optimisation

SELECT * FROM customer_orders_final;
SELECT * FROM runner_orders_final;
SELECT * FROM pizza_names;
SELECT * FROM pizza_recipes;
SELECT * FROM pizza_toppings;
SELECT * FROM runners;

-- 1. What are the standard ingredients for each pizza?
SELECT p.pizza_id, t.topping_name FROM pizza_toppings t
JOIN pizza_recipes p on t.topping_id = p.toppings

-- 2. What was the most commonly added extra?
SELECT exclusions, COUNT(exclusions) AS total_count
FROM customer_orders_final
WHERE exclusions LIKE '%'
GROUP BY exclusions;

-- 3. What was the most common exclusion?
SELECT extras, COUNT(extras) AS total_count
FROM customer_orders_final
WHERE extras LIKE '%'
GROUP BY extras;

-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
      
      -- Meat Lovers
SELECT order_id
FROM customer_orders_final
WHERE pizza_id = 1
GROUP BY order_id;

      -- Meat Lovers - Exclude Beef
SELECT order_id
FROM customer_orders_final
WHERE pizza_id = 1 and exclusions = 3
GROUP BY order_id;

      -- Meat Lovers - Extra Bacon
SELECT order_id
FROM customer_orders_final
WHERE pizza_id = 1 AND extras = 1
GROUP BY order_id;

      -- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
WITH CTE AS (SELECT order_id, CASE WHEN
						  exclusions IN (1,4) THEN 1 
					  WHEN extras IN (6,9) THEN 1 END AS ee_count
FROM customer_orders_final
WHERE pizza_id = 1)
SELECT DISTINCT order_id, ee_count FROM CTE
WHERE ee_count IS NOT NULL

-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of 
      -- any relevant ingredients
      -- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"


-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

