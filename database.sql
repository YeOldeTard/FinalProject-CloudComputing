-- Create database
CREATE DATABASE db_easyfood;

-- table account
CREATE TABLE account (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(30) NOT NULL,
    password VARCHAR(30) NOT NULL,
    shop_name VARCHAR(30) NOT NULL,
    shop_image VARCHAR(50)
);

-- table customer order
CREATE TABLE customer_order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(50) NOT NULL,
    customer VARCHAR(100) NOT NULL,
    date_order DATE NOT NULL,
    product_ordered VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status_order VARCHAR(30) NOT NULL
);


-- table product
CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_stock INT NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL
);

