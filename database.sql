-- Login
CREATE DATABASE db_easyfood;

-- Use
USE db_easyfood;

-- Login (seller)
CREATE TABLE account (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    shop_name VARCHAR(300) NOT NULL,
    shop_image VARCHAR(255) NULL    
);


-- Order
CREATE TABLE customer_order(
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(30) NOT NULL,
    customer VARCHAR(50) NOT NULL,
    date_order DATE NOT NULL,
    product_ordered VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10,0) NOT NULL,
    status_order VARCHAR(50) NOT NULL,
    is_archived tinyint(1) DEFAULT 0,
);

INSERT INTO customer_order (order_id, customer, date_order, product_ordered, quantity, total_price, status_order) VALUES ('NQPORWuhblBOZRV', 'Bahlil', '2025-12-25', 'Ethanol 100%', 100, 100000, 'Disiapkan');