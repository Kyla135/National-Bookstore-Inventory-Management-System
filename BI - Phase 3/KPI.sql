SELECT 
    YEAR(p.purchase_date) AS year,
    MONTH(p.purchase_date) AS month,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * o.price) AS total_revenue
FROM Orders o
JOIN Purchases p ON o.purchase_id = p.purchase_id
GROUP BY year, month
ORDER BY year DESC, month DESC;


SELECT 
    b.title, 
    b.author, 
    SUM(o.quantity) AS total_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
WHERE o.purchase_id IN (
    SELECT purchase_id FROM Purchases 
    WHERE purchase_date >= NOW() - INTERVAL 6 MONTH
)
GROUP BY b.book_id
ORDER BY total_sold DESC
LIMIT 5;

SELECT 
    s.name AS supplier_name, 
    COUNT(b.book_id) AS total_books_supplied, 
    SUM(b.stock_quantity) AS total_stock
FROM Suppliers s
JOIN Books b ON s.supplier_id = b.supplier_id
GROUP BY s.supplier_id
HAVING total_books_supplied > 10
ORDER BY total_stock DESC;


SELECT 
    u.username, 
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * o.price) AS total_spent
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id
HAVING total_orders > 0
ORDER BY total_spent DESC;

SELECT 
    b.title, 
    b.author, 
    b.stock_quantity, 
    s.name AS supplier_name, 
    s.contact_email
FROM Books b
JOIN Suppliers s ON b.supplier_id = s.supplier_id
WHERE b.stock_quantity < 10
ORDER BY b.stock_quantity ASC;
