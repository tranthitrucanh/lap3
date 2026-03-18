-- 1
SELECT u.user_id, u.user_name, o.order_id
FROM users u
JOIN orders o ON u.user_id = o.user_id;

-- 2
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS total_orders
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.user_name;

-- 3
SELECT o.order_id, COUNT(od.product_id) AS total_products
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id;

-- 4
SELECT u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
ORDER BY o.order_id;

-- 5
SELECT TOP 7 u.user_id, u.user_name, COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.user_name
ORDER BY total_orders DESC;

-- 6
SELECT TOP 7 u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE p.product_name LIKE '%Samsung%'
   OR p.product_name LIKE '%Apple%';

-- 7
SELECT u.user_id, u.user_name, o.order_id, 
SUM(p.product_price) AS total_price
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY u.user_id, u.user_name, o.order_id;

-- 8 (đơn hàng có giá lớn nhất mỗi user)
WITH order_total AS (
    SELECT u.user_id, u.user_name, o.order_id,
    SUM(p.product_price) AS total_price
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
)
SELECT *
FROM order_total ot
WHERE total_price = (
    SELECT MAX(total_price)
    FROM order_total
    WHERE user_id = ot.user_id
);

-- 9 (đơn hàng giá nhỏ nhất mỗi user)
WITH order_total AS (
    SELECT u.user_id, u.user_name, o.order_id,
    SUM(p.product_price) AS total_price,
    COUNT(p.product_id) AS total_products
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
)
SELECT *
FROM order_total ot
WHERE total_price = (
    SELECT MIN(total_price)
    FROM order_total
    WHERE user_id = ot.user_id
);

-- 10 (đơn hàng có nhiều sản phẩm nhất mỗi user)
WITH order_total AS (
    SELECT u.user_id, u.user_name, o.order_id,
    SUM(p.product_price) AS total_price,
    COUNT(p.product_id) AS total_products
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
)
SELECT *
FROM order_total ot
WHERE total_products = (
    SELECT MAX(total_products)
    FROM order_total
    WHERE user_id = ot.user_id
);