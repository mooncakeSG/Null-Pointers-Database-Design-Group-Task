CREATE DATABASE IF NOT EXISTS BookstoreDB;
USE BookstoreDB;

-- publisher table
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255)
);

-- book_language table
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100)
);

-- Author table
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- book table
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    language_id INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

-- Book_author Table--
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Customer Table --
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20)
);

-- Address Table--
CREATE TABLE address(
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT NOT NULL
);

-- Address Table Status--
CREATE TABLE address_status(
    address_status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) UNIQUE NOT NULL
);

-- Customer Address Table--
CREATE TABLE customer_address (
    customer_address_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    address_status_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

-- Country table --
CREATE TABLE country(
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- shipping_method table
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL
);
-- cust_order table--
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME NOT NULL,
    shipping_method_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id)
);

-- order_line table
CREATE TABLE order_line (
    order_line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- order_status table
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- order_history table
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    change_date DATETIME NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);


-- Insert values into  tables
INSERT INTO book_language (language_name) VALUES ('English'), ('French');
INSERT INTO publisher (name) VALUES ('Penguin'), ('HarperCollins');
INSERT INTO author (name) VALUES ('George Orwell'), ('J.K. Rowling');
INSERT INTO book (title, publisher_id, language_id, price)
VALUES ('1984', 1, 1, 12.99), ('Harry Potter', 2, 1, 29.99);
INSERT INTO country (country_name) VALUES('United States'),('South Africa'),('United Kingdom'),('Kenya');
INSERT INTO shipping_method (method_name, cost) VALUES ('Standard Shipping', 5.99), ('Express Shipping', 12.99), ('Overnight Shipping', 24.99);
INSERT INTO customer (first_name, last_name, email, phone_number)
VALUES
    ('Alice', 'Smith', 'alice.smith@example.com', '123-456-7890'),
    ('Bob', 'Johnson', 'bob.johnson@example.com', '987-654-3210'),
    ('Charlie', 'Brown', 'charlie.brown@example.com', '555-123-4567');
INSERT INTO cust_order (customer_id, order_date, shipping_method_id, total_amount) VALUES (1, '2025-04-10 10:30:00', 1, 50.00), (2, '2025-04-11 14:00:00', 2, 75.00), (3, '2025-04-12 09:15:00', 3, 120.00);
INSERT INTO order_status (status_name) VALUES ('Pending'), ('Shipped'), ('Delivered'), ('Cancelled');
INSERT INTO order_line (order_id, book_id, quantity, price) VALUES (1, 1, 2, 25.00), (1, 2, 1, 29.99), (2, 1, 1, 12.99), (3, 2, 3, 89.97);
INSERT INTO order_history (order_id, status_id, change_date)
VALUES (1, 1, '2025-04-10 11:00:00'), (1, 2, '2025-04-11 09:00:00'), (2, 1, '2025-04-11 15:00:00'), (3, 1, '2025-04-12 10:00:00'), (3, 3, '2025-04-13 12:00:00');
INSERT INTO address (street_address, city, region, postal_code, country_id) VALUES ('123 Main St', 'New York', 'NY', '10001', 1), ('456 Oak Ave', 'London','Lon', 'SW1A 1AA', 3),
('789 Maple Rd', 'Nairobi', 'Nai', '00100', 4);
INSERT INTO address_status (status_name) VALUES ('Primary'), ('Secondary'), ('Business'), ('Inactive');
INSERT INTO customer_address (customer_id, address_id, address_status_id) VALUES (1, 1, 1), (2, 2, 1), (3, 3, 1);

CREATE USER 'AdminUser'@'localhost' IDENTIFIED BY 'AdminPass123';
CREATE USER 'SalesUser'@'localhost' IDENTIFIED BY 'SalesPass123';
CREATE USER 'GuestUser'@'localhost' IDENTIFIED BY 'GuestPass123';

GRANT ALL PRIVILEGES ON BookstoreDB.* TO 'AdminUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON BookstoreDB.* TO 'SalesUser'@'localhost';
GRANT SELECT ON BookstoreDB.book TO 'GuestUser'@'localhost';

-- Top-selling books--
SELECT book.title, SUM(order_line.quantity) AS total_sold
FROM order_line
JOIN book ON book.book_id = order_line.book_id
GROUP BY book.book_id
ORDER BY total_sold DESC;

