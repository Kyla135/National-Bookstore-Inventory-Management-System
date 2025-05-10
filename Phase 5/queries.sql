USE national_bookstore_inventory_management_system;
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.isbn,
    b.price,
    b.stock_quantity,
    c.name AS classification
FROM books b
JOIN book_classifications bc ON b.book_id = bc.book_id
JOIN classifications c ON bc.classification_id = c.classification_id
ORDER BY b.book_id;

SELECT 
    b.book_id,
    b.title,
    b.author,
    b.isbn,
    b.price,
    b.stock_quantity,
    g.name AS genre,
    c.name AS classification
FROM books b
JOIN book_genres bg ON b.book_id = bg.book_id
JOIN genres g ON bg.genre_id = g.genre_id
JOIN book_classifications bc ON b.book_id = bc.book_id
JOIN classifications c ON bc.classification_id = c.classification_id
ORDER BY b.book_id;

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

-- Indexes for JOINs and WHERE
CREATE INDEX idx_books_book_id ON books(book_id);
CREATE INDEX idx_book_genres_book_id ON book_genres(book_id);
CREATE INDEX idx_book_genres_genre_id ON book_genres(genre_id);
CREATE INDEX idx_book_classifications_book_id ON book_classifications(book_id);
CREATE INDEX idx_book_classifications_classification_id ON book_classifications(classification_id);
CREATE INDEX idx_purchases_user_id ON purchases(user_id);
CREATE INDEX idx_purchases_purchase_date ON purchases(purchase_date);
CREATE INDEX idx_books_stock_quantity ON books(stock_quantity);
CREATE INDEX idx_purchases_item_type_item_id ON purchases(item_type, item_id);

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


