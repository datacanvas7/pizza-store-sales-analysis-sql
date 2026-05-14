--- SQL Beginner Project ---
-- With help of this tutorial: http://youtube.com/watch?v=zZpMvAedh_E --

-- Intermediate Level 
-- 1. Join the necessary tables to find the total quantity of each pizza category.
Select * from pizza_types;

Select pizza_types.category, 
count(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category 
order by quantity desc;
-- Answer: Classic	14579 orders
-- Supreme	11777 orders 
-- Veggie	11449 orders 
-- Chicken	10815 orders 


-- 2. Determine the distribution of orders by hour of the day.
Select * from orders;

SELECT DATEPART(HOUR, orders.time) AS order_hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY DATEPART(HOUR, orders.time)
ORDER BY order_count desc;
-- Answer: 12	2520
-- 13	2455
-- 18	2399

-- 3. Join relevant tables to find the category-wise distribution of pizzas.
Select * from pizza_types;

Select category, count(name) as items from pizza_types
group by category;
-- Answer: Chicken	6
-- Classic	8
-- Supreme	9
-- Veggie	9

-- 4. Group the orders by date and calculate the average number of pizzas ordered per day.
Select round(avg(quantity),0) as average_order_per_day from -- making subquery 
(Select orders.date, count(order_details.quantity) as quantity 
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.date) as order_quantity;
-- Answer: 135

-- 5. Determine the top 3 most ordered pizza types based on revenue.
Select * from orders;

SELECT TOP 3
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas
    ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
    ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC;
-- Answer: The Thai Chicken Pizza	43434.25
-- The Barbecue Chicken Pizza	42768
-- The California Chicken Pizza	41409.5

--------------------------------------------------------------------------------------------

