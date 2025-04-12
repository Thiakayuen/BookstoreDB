-- Create the bookstoreDB database  
CREATE DATABASE bookstoreDB;

-- Use the bookstore database
USE bookstoreDB;

--1 Create books table
CREATE TABLE book (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    language_id INT,
    publisher_id INT,
    publication_date DATE,
    FOREIGN KEY (language_id) REFERENCES book_language(id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(id)
);

--2 Create book_author table (many-to-many relationship)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (author_id) REFERENCES author(id)
);

--3 Create author table
CREATE TABLE author (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    birth_date DATE
);

--4 Create book_language table
CREATE TABLE book_language (
    id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(50) NOT NULL
);

--5 Create publisher table
CREATE TABLE publisher (
    id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    email VARCHAR(100)
);

--6 Create customer table
CREATE TABLE customer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--7 Create customer_address table
CREATE TABLE customer_address (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    address_id INT,
    status_id INT,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (address_id) REFERENCES address(id),
    FOREIGN KEY (status_id) REFERENCES address_status(id)
);

--8 Create address_status table
CREATE TABLE address_status (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL
);

--9 Create address table
CREATE TABLE address (
    id INT PRIMARY KEY AUTO_INCREMENT,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(id)
);

--10 Create country table
CREATE TABLE country (
    id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL,
    country_code VARCHAR(3) NOT NULL
);

--11 Create cust_order table
CREATE TABLE cust_order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    shipping_address_id INT,
    shipping_method_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (shipping_address_id) REFERENCES customer_address(id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(id),
    FOREIGN KEY (status_id) REFERENCES order_status(id)
);

--12 Create order_line table
CREATE TABLE order_line (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

--13 Create shipping_method table
CREATE TABLE shipping_method (
    id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

--14 Create order_history table
CREATE TABLE order_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    status_id INT,
    status_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (order_id) REFERENCES cust_order(id),
    FOREIGN KEY (status_id) REFERENCES order_status(id)
);

--15 Create order_status table
CREATE TABLE order_status (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL
);

-- Insert data into tables
-- Insert into country table
INSERT INTO country (country_name, country_code) VALUES
('United States', 'USA'),
('United Kingdom', 'GBR'),
('Canada', 'CAN'),
('Australia', 'AUS'),
('Germany', 'DEU');

-- Insert into book_language table
INSERT INTO book_language (language_name) VALUES
('English'),
('Spanish'),
('French'),
('German'),
('Italian');

-- Insert into publisher table
INSERT INTO publisher (publisher_name, address, email) VALUES
('Penguin Books', '80 Strand, London WC2R 0RL, UK', 'info@penguin.co.uk'),
('HarperCollins', '195 Broadway, New York, NY 10007, USA', 'contact@harpercollins.com'),
('Random House', '1745 Broadway, New York, NY 10019, USA', 'info@randomhouse.com'),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY 10020, USA', 'contact@simonandschuster.com'),
('Macmillan', '120 Broadway, New York, NY 10271, USA', 'info@macmillan.com');

-- Insert into author table
INSERT INTO author (first_name, last_name, email, birth_date) VALUES
('J.K.', 'Rowling', 'jkrowling@example.com', '1965-07-31'),
('George R.R.', 'Martin', 'grrm@example.com', '1948-09-20'),
('Stephen', 'King', 'sking@example.com', '1947-09-21'),
('Agatha', 'Christie', 'achristie@example.com', '1890-09-15'),
('Ernest', 'Hemingway', 'ehemingway@example.com', '1899-07-21');

-- Insert into address_status table
INSERT INTO address_status (status_name) VALUES
('Active'),
('Inactive'),
('Temporary'),
('Business');

-- Insert into shipping_method table
INSERT INTO shipping_method (method_name, price) VALUES
('Standard Shipping', 5.99),
('Express Shipping', 12.99),
('Overnight Shipping', 24.99),
('International Shipping', 19.99);

-- Insert into order_status table
INSERT INTO order_status (status_name) VALUES
('Pending'),
('Processing'),
('Shipped'),
('Delivered'),
('Cancelled');

-- Insert into address table
INSERT INTO address (street_address, city, state, postal_code, country_id) VALUES
('123 Main St', 'New York', 'NY', '10001', 1),
('456 Oxford St', 'London', NULL, 'W1D 1BS', 2),
('789 Queen St', 'Toronto', 'ON', 'M5H 2N2', 3),
('321 Collins St', 'Melbourne', 'VIC', '3000', 4),
('654 Friedrichstr', 'Berlin', NULL, '10117', 5);

-- Insert into customer table
INSERT INTO customer (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john.doe@example.com', '+1-212-555-1234'),
('Jane', 'Smith', 'jane.smith@example.com', '+44-20-7123-4567'),
('Robert', 'Johnson', 'robert.j@example.com', '+1-416-555-7890'),
('Emily', 'Brown', 'emily.b@example.com', '+61-3-9876-5432'),
('Michael', 'Schmidt', 'm.schmidt@example.com', '+49-30-1234-5678');

-- Insert into customer_address table
INSERT INTO customer_address (customer_id, address_id, status_id, is_default) VALUES
(1, 1, 1, TRUE),
(2, 2, 1, TRUE),
(3, 3, 1, TRUE),
(4, 4, 1, TRUE),
(5, 5, 1, TRUE);

-- Insert into book table
INSERT INTO book (title, isbn, price, quantity, language_id, publisher_id, publication_date) VALUES
('Harry Potter and the Philosopher''s Stone', '9780747532743', 19.99, 50, 1, 1, '1997-06-26'),
('A Game of Thrones', '9780553103540', 24.99, 35, 1, 2, '1996-08-01'),
('The Shining', '9780385121675', 15.99, 40, 1, 3, '1977-01-28'),
('Murder on the Orient Express', '9780062073495', 12.99, 30, 1, 4, '1934-01-01'),
('The Old Man and the Sea', '9780684801223', 10.99, 25, 1, 5, '1952-09-01');

-- Insert into book_author table
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert into cust_order table
INSERT INTO cust_order (customer_id, shipping_address_id, shipping_method_id, total_amount, status_id) VALUES
(1, 1, 1, 35.98, 1),
(2, 2, 2, 49.98, 2),
(3, 3, 3, 25.98, 3),
(4, 4, 4, 37.98, 4),
(5, 5, 1, 15.99, 1);

-- Insert into order_line table
INSERT INTO order_line (order_id, book_id, quantity, price) VALUES
(1, 1, 1, 19.99),
(1, 3, 1, 15.99),
(2, 2, 2, 24.99),
(3, 4, 1, 12.99),
(3, 5, 1, 10.99),
(4, 1, 1, 19.99),
(4, 2, 1, 24.99),
(5, 3, 1, 15.99);

-- Insert into order_history table
INSERT INTO order_history (order_id, status_id, notes) VALUES
(1, 1, 'Order received'),
(2, 2, 'Processing payment'),
(3, 3, 'Package shipped'),
(4, 4, 'Delivered successfully'),
(5, 1, 'New order'); 
