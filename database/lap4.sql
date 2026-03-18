CREATE DATABASE laptrinhweb;
GO

USE laptrinhweb;
GO

-- users
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL,
    user_email VARCHAR(55) NOT NULL,
    user_pass VARCHAR(255) NOT NULL,
    updated_at DATETIME,
    created_at DATETIME
);

-- products
CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_price FLOAT NOT NULL,
    product_description TEXT NOT NULL,
    updated_at DATETIME,
    created_at DATETIME
);

-- orders
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    updated_at DATETIME,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- order_details
CREATE TABLE order_details (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    updated_at DATETIME,
    created_at DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO users(user_name, user_email, user_pass)
VALUES 
('minh', 'minh@gmail.com', '123'),
('anh', 'anh@gmail.com', '123'),
('truc', 'truc@yahoo.com', '123'),
('mai', 'mai@gmail.com', '123'),
('huy', 'huy@gmail.com', '123'),
('trung', 'trung@yahoo.com', '123'),
('thanh', 'thanh@gmail.com', '123'),
('linh', 'linh@gmail.com', '123'),
('phuong', 'phuong@yahoo.com', '123'),
('manh', 'manh@gmail.com', '123'),
('khanh', 'khanh@gmail.com', '123');



-- PRODUCTS
INSERT INTO products(product_name, product_price, product_description) VALUES
('Samsung A1', 500, 'Phone'),
('Samsung TV', 800, 'Smart TV'),
('iPhone 14', 1000, 'Apple phone'),
('Macbook Air', 1500, 'Apple laptop'),
('Dell XPS', 1200, 'Laptop'),
('Asus Zenbook', 900, 'Laptop'),
('Apple Watch', 600, 'Smart watch');



INSERT INTO orders(user_id) VALUES
(1),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

INSERT INTO order_details(order_id, product_id) VALUES
(1,1),(1,2),
(2,3),
(3,1),
(4,2);