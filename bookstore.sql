-- Create and use the bookstore database
CREATE DATABASE IF NOT EXISTS bookstore;

USE bookstore;

-- Create book_language table
CREATE TABLE book_language (
    id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(50) NOT NULL
);

-- Create publisher table
CREATE TABLE publisher (
    id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    email VARCHAR(100)
);

-- Create author table
CREATE TABLE author (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    birth_date DATE
);

-- Create book_category table
CREATE TABLE book_category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    parent_category_id INT,
    description TEXT,
    FOREIGN KEY (parent_category_id) REFERENCES book_category(id)
);

-- Create book_condition table
CREATE TABLE book_condition (
    id INT PRIMARY KEY AUTO_INCREMENT,
    condition_name VARCHAR(50) NOT NULL,
    description TEXT,
    discount_percentage DECIMAL(5,2) DEFAULT 0.00
);

-- Create books table
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    language_id INT,
    publisher_id INT,
    publication_date DATE,
    category_id INT,
    condition_id INT,
    minimum_stock_level INT DEFAULT 10,
    description TEXT,
    cover_image_url VARCHAR(255),
    FOREIGN KEY (language_id) REFERENCES book_language(id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(id),
    FOREIGN KEY (category_id) REFERENCES book_category(id),
    FOREIGN KEY (condition_id) REFERENCES book_condition(id)
);

-- Create book_author table (many-to-many relationship)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (author_id) REFERENCES author(id)
);

-- Create book_review table
CREATE TABLE book_review (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    customer_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

-- Create country table
CREATE TABLE country (
    id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL,
    country_code VARCHAR(3) NOT NULL
);

-- Create address table
CREATE TABLE address (
    id INT PRIMARY KEY AUTO_INCREMENT,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(id)
);

-- Create address_status table
CREATE TABLE address_status (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL
);

-- Create customer table
CREATE TABLE customer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    loyalty_points INT DEFAULT 0,
    membership_level ENUM('Standard', 'Silver', 'Gold', 'Platinum') DEFAULT 'Standard',
    last_purchase_date DATE
);

-- Create customer_address table
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

-- Create payment_method table
CREATE TABLE payment_method (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    payment_type ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer') NOT NULL,
    card_number VARCHAR(20),
    expiry_date DATE,
    card_holder_name VARCHAR(100),
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

-- Create shipping_method table
CREATE TABLE shipping_method (
    id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    estimated_delivery_days INT,
    is_available BOOLEAN DEFAULT TRUE
);

-- Create order_status table
CREATE TABLE order_status (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL
);

-- Create cust_order table
CREATE TABLE cust_order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    shipping_address_id INT,
    shipping_method_id INT,
    payment_method_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    loyalty_points_earned INT DEFAULT 0,
    loyalty_points_used INT DEFAULT 0,
    status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (shipping_address_id) REFERENCES customer_address(id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_method(id),
    FOREIGN KEY (status_id) REFERENCES order_status(id)
);

-- Create order_line table
CREATE TABLE order_line (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount_percentage DECIMAL(5,2) DEFAULT 0.00,
    FOREIGN KEY (order_id) REFERENCES cust_order(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- Create order_history table
CREATE TABLE order_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    status_id INT,
    status_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (order_id) REFERENCES cust_order(id),
    FOREIGN KEY (status_id) REFERENCES order_status(id)
);

-- Create inventory_alert table
CREATE TABLE inventory_alert (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    alert_type ENUM('Low Stock', 'Out of Stock', 'Back in Stock') NOT NULL,
    alert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved_date TIMESTAMP NULL,
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- Insert sample data for book_category
INSERT INTO book_category (category_name, description) VALUES 
('Fiction', 'Works of fiction including novels and short stories'),
('Non-Fiction', 'Factual works including biographies and educational books'),
('Science Fiction', 'Speculative fiction dealing with futuristic concepts'),
('Mystery', 'Works involving crime and investigation'),
('Fantasy', 'Works involving magic and supernatural elements');

-- Insert sample data for book_condition
INSERT INTO book_condition (condition_name, description, discount_percentage) VALUES 
('New', 'Brand new, never used', 0.00),
('Like New', 'Almost new, minimal wear', 5.00),
('Very Good', 'Minor wear and tear', 10.00),
('Good', 'Noticeable wear but still readable', 20.00),
('Fair', 'Significant wear, may have markings', 30.00);

-- Insert sample data for book_language
INSERT INTO book_language (language_name) VALUES 
('English'),
('Spanish'),
('French'),
('German'),
('Italian');

-- Insert sample data for publisher
INSERT INTO publisher (publisher_name, address, email) VALUES 
('Penguin Books', '80 Strand, London WC2R 0RL, UK', 'contact@penguin.co.uk'),
('HarperCollins', '195 Broadway, New York, NY 10007, USA', 'info@harpercollins.com'),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY 10020, USA', 'contact@simonandschuster.com'),
('Random House', '1745 Broadway, New York, NY 10019, USA', 'info@randomhouse.com');

-- Insert sample data for author
INSERT INTO author (first_name, last_name, email, birth_date) VALUES 
('J.K.', 'Rowling', 'jkrowling@example.com', '1965-07-31'),
('George R.R.', 'Martin', 'grrm@example.com', '1948-09-20'),
('Stephen', 'King', 'sking@example.com', '1947-09-21'),
('Agatha', 'Christie', 'achristie@example.com', '1890-09-15'),
('J.R.R.', 'Tolkien', 'jrrtolkien@example.com', '1892-01-03');

-- Insert sample data for books
INSERT INTO books (title, isbn, price, quantity, language_id, publisher_id, publication_date, category_id, condition_id, minimum_stock_level, description) VALUES 
('Harry Potter and the Philosopher''s Stone', '9780747532743', 19.99, 100, 1, 1, '1997-06-26', 5, 1, 20, 'The first book in the Harry Potter series'),
('A Game of Thrones', '9780553103540', 24.99, 75, 1, 2, '1996-08-01', 5, 1, 15, 'The first book in A Song of Ice and Fire series'),
('The Shining', '9780385121675', 15.99, 50, 1, 3, '1977-01-28', 1, 1, 10, 'A horror novel by Stephen King'),
('Murder on the Orient Express', '9780007119318', 12.99, 60, 1, 4, '1934-01-01', 4, 1, 10, 'A Hercule Poirot mystery'),
('The Hobbit', '9780261102217', 18.99, 80, 1, 1, '1937-09-21', 5, 1, 15, 'A fantasy novel by J.R.R. Tolkien');

-- Insert sample data for book_author
INSERT INTO book_author (book_id, author_id) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert sample data for country
INSERT INTO country (country_name, country_code) VALUES 
('United States', 'USA'),
('United Kingdom', 'GBR'),
('Canada', 'CAN'),
('Australia', 'AUS'),
('Germany', 'DEU');

-- Insert sample data for address
INSERT INTO address (street_address, city, state, postal_code, country_id) VALUES 
('123 Main St', 'New York', 'NY', '10001', 1),
('456 Oxford St', 'London', NULL, 'W1D 1BS', 2),
('789 Queen St', 'Toronto', 'ON', 'M5H 2N2', 3),
('321 George St', 'Sydney', 'NSW', '2000', 4),
('654 Friedrichstr', 'Berlin', NULL, '10117', 5);

-- Insert sample data for address_status
INSERT INTO address_status (status_name) VALUES 
('Current'),
('Previous'),
('Billing'),
('Shipping');

-- Insert sample data for customer
INSERT INTO customer (first_name, last_name, email, phone, loyalty_points, membership_level, last_purchase_date) VALUES 
('John', 'Doe', 'john.doe@example.com', '555-123-4567', 500, 'Silver', '2024-03-15'),
('Jane', 'Smith', 'jane.smith@example.com', '555-987-6543', 1200, 'Gold', '2024-03-20'),
('Robert', 'Johnson', 'robert.johnson@example.com', '555-456-7890', 250, 'Standard', '2024-02-28'),
('Emily', 'Davis', 'emily.davis@example.com', '555-789-0123', 800, 'Silver', '2024-03-10'),
('Michael', 'Wilson', 'michael.wilson@example.com', '555-234-5678', 1500, 'Platinum', '2024-03-18');

-- Insert sample data for customer_address
INSERT INTO customer_address (customer_id, address_id, status_id, is_default) VALUES 
(1, 1, 1, TRUE),
(1, 2, 3, FALSE),
(2, 3, 1, TRUE),
(3, 4, 1, TRUE),
(4, 5, 1, TRUE);

-- Insert sample data for payment_method
INSERT INTO payment_method (customer_id, payment_type, card_number, expiry_date, card_holder_name, is_default) VALUES 
(1, 'Credit Card', '4111111111111111', '2025-12-31', 'John Doe', TRUE),
(2, 'Debit Card', '4222222222222222', '2024-10-31', 'Jane Smith', TRUE),
(3, 'PayPal', NULL, NULL, 'Robert Johnson', TRUE),
(4, 'Credit Card', '4333333333333333', '2026-06-30', 'Emily Davis', TRUE),
(5, 'Debit Card', '4444444444444444', '2025-03-31', 'Michael Wilson', TRUE);

-- Insert sample data for shipping_method
INSERT INTO shipping_method (method_name, price, estimated_delivery_days, is_available) VALUES 
('Standard Shipping', 5.99, 5, TRUE),
('Express Shipping', 12.99, 2, TRUE),
('Overnight Shipping', 24.99, 1, TRUE);

-- Insert sample data for order_status
INSERT INTO order_status (status_name) VALUES 
('Pending'),
('Processing'),
('Shipped'),
('Delivered'),
('Cancelled');

-- Insert sample data for cust_order
INSERT INTO cust_order (customer_id, shipping_address_id, shipping_method_id, payment_method_id, total_amount, discount_amount, loyalty_points_earned, loyalty_points_used, status_id) VALUES 
(1, 1, 1, 1, 45.97, 2.30, 45, 0, 1),
(2, 3, 2, 2, 37.98, 1.90, 38, 0, 2),
(3, 4, 1, 3, 24.99, 0.00, 25, 0, 3),
(4, 5, 3, 4, 52.97, 5.30, 53, 0, 4),
(5, 1, 2, 5, 31.98, 1.60, 32, 0, 1);

-- Insert sample data for order_line
INSERT INTO order_line (order_id, book_id, quantity, price, discount_percentage) VALUES 
(1, 1, 1, 19.99, 0.00),
(1, 3, 1, 15.99, 0.00),
(2, 2, 1, 24.99, 0.00),
(3, 4, 1, 12.99, 0.00),
(4, 5, 2, 18.99, 0.00),
(5, 1, 1, 19.99, 0.00);

-- Insert sample data for order_history
INSERT INTO order_history (order_id, status_id, notes) VALUES 
(1, 1, 'Order received'),
(2, 2, 'Processing payment'),
(3, 3, 'Package shipped'),
(4, 4, 'Delivered successfully'),
(5, 1, 'New order');

-- Insert sample data for book_review
INSERT INTO book_review (book_id, customer_id, rating, review_text, is_verified_purchase) VALUES 
(1, 1, 5, 'Amazing book! Couldn''t put it down.', TRUE),
(2, 2, 4, 'Great start to the series.', TRUE),
(3, 3, 5, 'Classic horror at its best.', TRUE),
(4, 4, 4, 'Clever mystery with a surprising ending.', TRUE),
(5, 5, 5, 'A timeless fantasy masterpiece.', TRUE);

-- Insert sample data for inventory_alert
INSERT INTO inventory_alert (book_id, alert_type, is_resolved) VALUES 
(3, 'Low Stock', FALSE),
(4, 'Low Stock', FALSE);





