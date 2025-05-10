CREATE TABLE dim_users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    role VARCHAR(50)
);


CREATE TABLE dim_items (
    item_id INT,
    item_type VARCHAR(50),
    name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10,2),
    PRIMARY KEY (item_id, item_type)
);


CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    year INT,
    quarter INT
);


CREATE TABLE dim_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100)
);


CREATE TABLE fact_purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT,
    item_id INT,
    item_type VARCHAR(50),
    date_id INT,
    category_id INT,
    quantity INT,
    total_price DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES dim_users(user_id),
    FOREIGN KEY (item_id, item_type) REFERENCES dim_items(item_id, item_type),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id)
);