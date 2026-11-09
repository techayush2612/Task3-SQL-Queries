SELECT 'Total Customers' AS analysis,
       CAST(COUNT(*) AS TEXT) AS result
FROM customers

UNION ALL

SELECT 'Customers in SP',
       CAST(COUNT(*) AS TEXT)
FROM customers
WHERE customer_state = 'SP'

UNION ALL

SELECT 'Total Revenue',
       CAST(ROUND(SUM(payment_value), 2) AS TEXT)
FROM order_payments

UNION ALL

SELECT 'Average Payment',
       CAST(ROUND(AVG(payment_value), 2) AS TEXT)
FROM order_payments

UNION ALL

SELECT 'Order Status: ' || order_status,
       CAST(COUNT(*) AS TEXT)
FROM order_dataset
GROUP BY order_status

ORDER BY analysis;


SELECT
    'INNER JOIN' AS join_type,
    COUNT(*) AS total_records
FROM sellers s
INNER JOIN orders_items oi
ON s.seller_id = oi.seller_id

UNION ALL

SELECT
    'LEFT JOIN',
    COUNT(*)
FROM sellers s
LEFT JOIN orders_items oi
ON s.seller_id = oi.seller_id

UNION ALL

SELECT
    'RIGHT JOIN',
    COUNT(*)
FROM orders_items oi
RIGHT JOIN sellers s
ON oi.seller_id = s.seller_id;


SELECT
    product_id,
    ROUND(MAX(price), 2) AS product_price
FROM orders_items
GROUP BY product_id
HAVING MAX(price) >
    (SELECT AVG(price) FROM orders_items)
ORDER BY product_price DESC
LIMIT 10;


CREATE VIEW IF NOT EXISTS seller_sales_summary AS
SELECT
    seller_id,
    COUNT(*) AS total_items_sold,
    ROUND(SUM(price), 2) AS total_sales,
    ROUND(AVG(price), 2) AS average_price
FROM orders_items
GROUP BY seller_id;

SELECT *
FROM seller_sales_summary
ORDER BY total_sales DESC
LIMIT 10;

CREATE INDEX IF NOT EXISTS idx_orders_timestamp
ON order_dataset(order_purchase_timestamp);

CREATE INDEX IF NOT EXISTS idx_items_product
ON orders_items(product_id);

CREATE INDEX IF NOT EXISTS idx_items_seller
ON orders_items(seller_id);

EXPLAIN QUERY PLAN
SELECT *
FROM orders_items
WHERE product_id = (
    SELECT product_id
    FROM orders_items
    LIMIT 1
);