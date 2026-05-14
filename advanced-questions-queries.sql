--- SQL Beginner Project ---
-- With help of this tutorial: http://youtube.com/watch?v=zZpMvAedh_E --

-- Advanced Level 
-- 1. Calculate the percentage contribution of each pizza type to total revenue.
Select * from pizzas;

SELECT 
    pizza_types.category,
    (round (SUM(order_details.quantity * pizzas.price) /
        (
            SELECT ROUND(SUM(order_details.quantity * pizzas.price), 2)
            FROM order_details
            JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
        ) * 100,2)
    ) AS revenue_percentage
FROM pizza_types
JOIN pizzas 
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details 
    ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue_percentage DESC;
-- Answer: Classic	26.91
-- Supreme	25.46
-- Chicken	23.96
-- Veggie	23.68

-- 2. Analyze the cumulative revenue generated over time.
Select * from orders;

SELECT 
    sales.date, 
    SUM(revenue) OVER (ORDER BY sales.date) AS cum_revenue
FROM (
    SELECT 
        orders.date, 
        SUM(order_details.quantity * pizzas.price) AS revenue
    FROM order_details
    JOIN pizzas
        ON order_details.pizza_id = pizzas.pizza_id
    JOIN orders 
        ON orders.order_id = order_details.order_id
    GROUP BY orders.date
) AS sales;
-- Answer: 2015-01-01	2713.85000228882
-- 2015-01-02	5445.7500038147
-- 2015-01-03	8108.15000724792

-- 3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
Select * from pizza_types;

SELECT name, revenue
FROM (
    SELECT 
        category,
        name,
        revenue,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT 
            pizza_types.category,
            pizza_types.name,
            SUM(order_details.quantity * pizzas.price) AS revenue
        FROM pizza_types
        JOIN pizzas
            ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN order_details 
            ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY pizza_types.category, pizza_types.name
    ) AS a
) AS b
WHERE rn <= 3;
-- Answer: The Thai Chicken Pizza	43434.25
--  The Barbecue Chicken Pizza	42768
-- The California Chicken Pizza	41409.5
-- The Classic Deluxe Pizza	38180.5
-- The Hawaiian Pizza	32273.25
-- The Pepperoni Pizza	30161.75
-- The Spicy Italian Pizza	34831.25
-- The Italian Supreme Pizza	33476.75
-- The Sicilian Pizza	30940.5
-- The Four Cheese Pizza	32265.7010040283
-- The Mexicana Pizza	26780.75
-- The Five Cheese Pizza	26066.5

------------------------------------------------------------------------------------------------------------------------

