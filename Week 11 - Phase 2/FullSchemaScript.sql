CREATE DATABASE IF NOT EXISTS national_bookstore_inventory_management_system;
USE national_bookstore_inventory_management_system;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    isbn VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Classifications
CREATE TABLE classifications (
    classification_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE book_genres (
    book_id INT,
    genre_id INT,
    PRIMARY KEY (book_id, genre_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE
);

CREATE TABLE book_classifications (
    book_id INT,
    classification_id INT,
    PRIMARY KEY (book_id, classification_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (classification_id) REFERENCES classifications(classification_id) ON DELETE CASCADE
);

CREATE TABLE school_supplies (
    supply_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    quantity INT,
    unit VARCHAR(50),
    price DECIMAL(10,2),
    brand VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE office_supplies (
    supply_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    quantity INT,
    unit VARCHAR(50),
    price DECIMAL(10,2),
    brand VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE toys_and_games (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100),
    price DECIMAL(10,2),
    stock_quantity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    item_type VARCHAR(50),
    item_id INT,
    quantity INT,
    total_price DECIMAL(10,2),
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255),
    table_name VARCHAR(100),
    record_id INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

SELECT COUNT(*) FROM books;
SELECT COUNT(*) FROM office_supplies;
SELECT COUNT(*) FROM school_supplies;
SELECT COUNT(*) FROM toys_and_games;
SELECT COUNT(*) FROM genres;
SELECT COUNT(*) FROM  classifications;
SELECT COUNT(*) FROM  book_genres;
SELECT COUNT(*) FROM  book_classifications;
SELECT COUNT(*) FROM audit_logs;
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM purchases;

-- genres, classfication insertion

INSERT INTO genres (name) VALUES 
('Fiction'),
('Non-fiction'),
('Mystery'),
('Science Fiction'),
('Biography');

INSERT INTO classifications (name) VALUES 
('Educational'),
('Entertainment'),
('Reference'),
('Literature'),
('Textbook');

INSERT INTO book_genres (book_id, genre_id)
SELECT book_id, (SELECT genre_id FROM genres WHERE name = 'Fiction')
FROM books
ORDER BY book_id
LIMIT 20000;

INSERT INTO book_genres (book_id, genre_id)
SELECT book_id, (SELECT genre_id FROM genres WHERE name = 'Non-fiction')
FROM books
ORDER BY book_id
LIMIT 20000 OFFSET 20000;

INSERT INTO book_genres (book_id, genre_id)
SELECT book_id, (SELECT genre_id FROM genres WHERE name = 'Mystery')
FROM books
ORDER BY book_id
LIMIT 20000 OFFSET 40000;

INSERT INTO book_genres (book_id, genre_id)
SELECT book_id, (SELECT genre_id FROM genres WHERE name = 'Science Fiction')
FROM books
ORDER BY book_id
LIMIT 20000 OFFSET 60000;

INSERT INTO book_genres (book_id, genre_id)
SELECT book_id, (SELECT genre_id FROM genres WHERE name = 'Biography')
FROM books
ORDER BY book_id
LIMIT 20000 OFFSET 80000;

INSERT INTO book_classifications (book_id, classification_id)
SELECT book_id, (SELECT classification_id FROM classifications WHERE name = 'Educational')
FROM books
ORDER BY book_id
LIMIT 20000;

INSERT INTO book_classifications (book_id, classification_id)
SELECT book_id, (SELECT classification_id FROM classifications WHERE name = 'Entertainment')
FROM books
ORDER BY book_id
LIMIT 20000 OFFSET 20000;

INSERT INTO book_classifications (book_id, classification_id)
SELECT book_id, (SELECT classification_id FROM classifications WHERE name = 'Reference')
FROM books
ORDER BY book_id
LIMIT 20000 OFFSET 40000;

INSERT INTO book_classifications (book_id, classification_id)
SELECT book_id, (SELECT classification_id FROM classifications WHERE name = 'Literature')
FROM books
ORDER BY book_id
LIMIT 20000 OFFSET 60000;

INSERT INTO book_classifications (book_id, classification_id)
SELECT book_id, (SELECT classification_id FROM classifications WHERE name = 'Textbook')
FROM books
ORDER BY book_id
LIMIT 20000 OFFSET 80000;

SELECT 
    b.book_id,
    b.title,
    b.author,
    b.isbn,
    b.price,
    b.stock_quantity,
    g.name AS genre
FROM books b
JOIN book_genres bg ON b.book_id = bg.book_id
JOIN genres g ON bg.genre_id = g.genre_id
ORDER BY b.book_id;

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
