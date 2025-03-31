CREATE TABLE Users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'User') DEFAULT 'User'
);

CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    genre VARCHAR(50),
    stock_quantity INT NOT NULL,
    supplier_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);


CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_cost DECIMAL(10, 2),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (purchase_id) REFERENCES Purchases(purchase_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
CREATE TABLE AuditLogs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    action ENUM('Create', 'Update', 'Delete'),
    table_name VARCHAR(50),
    changed_data TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);