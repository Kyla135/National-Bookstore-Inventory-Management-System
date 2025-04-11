CREATE DATABASE InventoryManagementSystem;
USE InventoryManagementSystem;

CREATE TABLE Users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'User') DEFAULT 'User'
);

SELECT*FROM Users;

CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT*FROM Suppliers;
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10 , 2 ) NOT NULL,
    description TEXT,
    genre VARCHAR(50),
    stock_quantity INT NOT NULL,
    supplier_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id)
        REFERENCES Suppliers (supplier_id)
);


SELECT*FROM Books;
SELECT COUNT(*) FROM Books;

CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_cost DECIMAL(10, 2),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);
SELECT*FROM Purchases;


CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (purchase_id) REFERENCES Purchases(purchase_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
SELECT*FROM Orders;

CREATE TABLE AuditLogs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    action ENUM('Create', 'Update', 'Delete'),
    table_name VARCHAR(50),
    changed_data TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT*FROM AuditLogs;

ALTER TABLE Books ADD CONSTRAINT stock_quantity_check CHECK (stock_quantity >= 0);
ALTER TABLE Books ADD CONSTRAINT price_check CHECK (price >= 0);

INSERT INTO Books (title, author, price, description, genre, stock_quantity, supplier_id, created_at)
SELECT 
    CONCAT('Book', FLOOR(RAND() * 100000)), 
    CONCAT('Author', FLOOR(RAND() * 1000)), 
    ROUND(RAND() * 50 + 5, 2),  -- Price between 5 and 55
    'Generated book description', 
    (CASE FLOOR(RAND() * 5)  
        WHEN 0 THEN 'Fiction'  
        WHEN 1 THEN 'Non-Fiction'  
        WHEN 2 THEN 'Science'  
        WHEN 3 THEN 'History'  
        ELSE 'Biography'  
     END),
    FLOOR(RAND() * 100),  -- Random stock quantity (0-99)
    (SELECT supplier_id FROM Suppliers ORDER BY RAND() LIMIT 1),  -- Random existing supplier
    NOW()
FROM information_schema.tables LIMIT 100000;

INSERT INTO Users (username, password, role)
SELECT 
    CONCAT('User', FLOOR(RAND() * 100000)), 
    SHA2(CONCAT('Password', FLOOR(RAND() * 100000)), 256), -- Encrypting passwords
    (CASE WHEN RAND() < 0.1 THEN 'Admin' ELSE 'User' END) -- 10% Admins, 90% Users
FROM information_schema.tables LIMIT 100000;

INSERT INTO Suppliers (name, contact_email, contact_phone, address, created_at)
SELECT 
    CONCAT('Supplier', FLOOR(RAND() * 100000)), 
    CONCAT('supplier', FLOOR(RAND() * 100000), '@vendor.com'),
    CONCAT('+1-555-', FLOOR(RAND() * 9000 + 1000)), 
    CONCAT('Street ', FLOOR(RAND() * 1000), ', City'),
    NOW()
FROM information_schema.tables LIMIT 100000;

-- row count
SELECT 
    table_name,
    (SELECT COUNT(*) FROM auditlogs) AS row_count
FROM information_schema.tables
WHERE table_schema = 'inventorymanagementsystem'
  AND table_type = 'BASE TABLE'
ORDER BY row_count DESC;




SELECT 
    SUM(o.quantity * o.price) AS total_revenue, 
    COUNT(o.order_id) AS total_orders, 
    COUNT(DISTINCT o.book_id) AS unique_books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id;

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
    YEAR(p.purchase_date) AS year,
    MONTH(p.purchase_date) AS month,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity) AS total_books_sold,
    SUM(o.quantity * o.price) AS total_revenue
FROM Orders o
JOIN Purchases p ON o.purchase_id = p.purchase_id
GROUP BY year, month
ORDER BY year DESC, month DESC;

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
    b.title, 
    b.author, 
    b.stock_quantity, 
    s.name AS supplier_name, 
    s.contact_email
FROM Books b
JOIN Suppliers s ON b.supplier_id = s.supplier_id
WHERE b.stock_quantity < 10
ORDER BY b.stock_quantity ASC;

SELECT SUM(quantity * price) AS total_revenue FROM Orders;

SELECT 
    s.name AS supplier_name,
    COUNT(p.purchase_id) AS total_purchases,
    SUM(p.total_cost) AS total_spent
FROM
    Purchases p
        JOIN
    Suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_id
ORDER BY total_spent DESC;


SELECT COUNT(*) AS low_stock_books FROM Books WHERE stock_quantity < 10;

SELECT YEAR(p.purchase_date) AS year, MONTH(p.purchase_date) AS month, 
       SUM(o.quantity * o.price) AS total_revenue
FROM Orders o
JOIN Purchases p ON o.purchase_id = p.purchase_id
GROUP BY year, month
ORDER BY year DESC, month DESC;


CREATE TABLE IF NOT EXISTS Numbers2 (n INT PRIMARY KEY);


INSERT IGNORE INTO Numbers2(n)
SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL
SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL
SELECT 10;


INSERT IGNORE INTO Numbers2(n) SELECT n + 10 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 20 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 40 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 80 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 160 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 320 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 640 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 1280 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 2560 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 5120 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 10240 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 20480 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 40960 FROM Numbers2;
INSERT IGNORE INTO Numbers2(n) SELECT n + 81920 FROM Numbers2;


INSERT INTO Books (title, author, price, description, genre, stock_quantity, supplier_id, created_at)
SELECT
    CONCAT('Book ', n),
    CONCAT('Author ', n),
    ROUND(RAND() * 50 + 5, 2),
    'Generated book description',
    (CASE FLOOR(RAND() * 5)
        WHEN 0 THEN 'Fiction'
        WHEN 1 THEN 'Non-Fiction'
        WHEN 2 THEN 'Science'
        WHEN 3 THEN 'History'
        ELSE 'Biography'
     END),
    FLOOR(RAND() * 100),
    (SELECT supplier_id FROM Suppliers ORDER BY RAND() LIMIT 1),
    NOW()
FROM Numbers2
LIMIT 100000;