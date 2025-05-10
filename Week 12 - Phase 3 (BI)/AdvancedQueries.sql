
SELECT 
    item_type,
    YEAR(purchase_date) AS year,
    MONTH(purchase_date) AS month,
    SUM(total_price) AS monthly_revenue
FROM purchases
GROUP BY item_type, YEAR(purchase_date), MONTH(purchase_date)
ORDER BY year, month, item_type;

SELECT 
    item_type,
    item_id,
    SUM(quantity) AS total_quantity_sold
FROM purchases
GROUP BY item_type, item_id
ORDER BY total_quantity_sold DESC
LIMIT 5;

SELECT 
    u.username,
    COUNT(p.purchase_id) AS total_transactions,
    SUM(p.total_price) AS total_sales
FROM purchases p
JOIN users u ON p.user_id = u.user_id
GROUP BY u.user_id
ORDER BY total_sales DESC;

SELECT 
    title,
    stock_quantity
FROM books
WHERE stock_quantity < 10
ORDER BY stock_quantity ASC;

SELECT 
    YEAR(purchase_date) AS year,
    MONTH(purchase_date) AS month,
    SUM(total_price) AS total_sales
FROM purchases
GROUP BY YEAR(purchase_date), MONTH(purchase_date)
ORDER BY year, month;
