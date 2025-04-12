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
    FOREIGN KEY (language_id) REFERENCES book_language(id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(id)
);

-- Create book_author table (many-to-many relationship)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (author_id) REFERENCES author(id)
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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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

-- Create shipping_method table
CREATE TABLE shipping_method (
    id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
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
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (shipping_address_id) REFERENCES customer_address(id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(id),
    FOREIGN KEY (status_id) REFERENCES order_status(id)
);

-- Create order_line table
CREATE TABLE order_line (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
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