-- Total Sales
SELECT SUM(price) AS Product_Revenue,
    SUM(freight_value) AS Freight_Revenue,
    SUM(price + freight_value) AS Total_Revenue
FROM order_items;

-- Total Orders
SELECT
    COUNT(DISTINCT order_id) AS Total_Orders
FROM orders;

-- total customers
SELECT
    COUNT(DISTINCT customer_unique_id) AS Total_Customers
FROM customers;

-- Average Order Value
SELECT
    SUM(oi.price + oi.freight_value)
    / COUNT(DISTINCT oi.order_id) AS Average_Order_Value
FROM order_items oi;

-- Monthly Revenue
SELECT
    YEAR(o.order_purchase_timestamp) AS Sales_Year,
    MONTH(o.order_purchase_timestamp) AS Sales_Month,
    SUM(oi.price + oi.freight_value) AS Revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    Sales_Year,
    Sales_Month;

-- Revenue by Product Category
SELECT
    p.product_category_name,
    SUM(oi.price + oi.freight_value) AS Revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_category_name
ORDER BY
    Revenue DESC;

-- Top 10 Products
SELECT TOP 10
    oi.product_id,
    SUM(oi.price) AS Product_Revenue,
    COUNT(*) AS Units_Sold
FROM order_items oi
GROUP BY
    oi.product_id
ORDER BY
    Product_Revenue DESC;

-- Order Status Analysis
SELECT
    order_status,
    COUNT(*) AS Orders
FROM orders
GROUP BY
    order_status
ORDER BY
    Orders DESC;

SELECT
    order_status,
    COUNT(*) AS Orders,
    CAST(COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS Percentage
FROM orders
GROUP BY
    order_status
ORDER BY
    Orders DESC;

-- Customer Repeat Purchase
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Number_of_Orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_unique_id
ORDER BY
    Number_of_Orders DESC;


WITH CustomerOrders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Number_of_Orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)

SELECT
    CASE
        WHEN Number_of_Orders = 1 THEN 'One-Time'
        WHEN Number_of_Orders = 2 THEN 'Returning'
        ELSE 'Loyal'
    END AS Customer_Segment,
    COUNT(*) AS Customers
FROM CustomerOrders
GROUP BY
    CASE
        WHEN Number_of_Orders = 1 THEN 'One-Time'
        WHEN Number_of_Orders = 2 THEN 'Returning'
        ELSE 'Loyal'
    END;


-- Customer Revenue
SELECT TOP 10
    c.customer_unique_id,
    SUM(oi.price + oi.freight_value) AS Customer_Revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_unique_id
ORDER BY
    Customer_Revenue DESC;


-- Average Review Score
SELECT
    AVG(CAST(review_score AS DECIMAL(10,2))) AS Average_Review_Score
FROM order_reviews;

SELECT
    review_score,
    COUNT(*) AS Reviews
FROM order_reviews
GROUP BY
    review_score
ORDER BY
    review_score;


-- 

