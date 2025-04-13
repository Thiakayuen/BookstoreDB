CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE author (
    author_id INT AUTO_INCREMENT,
    author_name VARCHAR(400) NOT NULL,
    PRIMARY KEY (author_id)
);

CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT,
    language_code VARCHAR(8),
    language_name VARCHAR(50),
    PRIMARY KEY (language_id)
);

CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT,
    publisher_name VARCHAR(400) NOT NULL,
    PRIMARY KEY (publisher_id)
);

CREATE TABLE book (
    book_id INT AUTO_INCREMENT,
    isbn13 VARCHAR(13) UNIQUE,
    title VARCHAR(400) NOT NULL,
    num_pages INT,
    publication_date DATE,
    language_id INT,
    publisher_id INT,
    PRIMARY KEY (book_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE TABLE address (
    address_id INT AUTO_INCREMENT,
    street_number VARCHAR(10),
    street_name VARCHAR(200),
    city VARCHAR(100),
    country_id INT,
    PRIMARY KEY (address_id)
);

CREATE TABLE country (
    country_id INT AUTO_INCREMENT,
    country_name VARCHAR(200),
    PRIMARY KEY (country_id)
);

CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT,
    address_status VARCHAR(30),
    PRIMARY KEY (status_id)
);

CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT,
    first_name VARCHAR(200),
    last_name VARCHAR(200),
    email VARCHAR(350) UNIQUE,
    PRIMARY KEY (customer_id)
);

CREATE TABLE shipping_method (
    method_id INT AUTO_INCREMENT,
    method_name VARCHAR(100),
    cost DECIMAL(6,2),
    PRIMARY KEY (method_id)
);

CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT,
    order_date DATETIME,
    customer_id INT,
    dest_address_id INT,
    shipping_method_id INT,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (dest_address_id) REFERENCES address(address_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id)
);

CREATE TABLE order_line (
    line_id INT AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    price DECIMAL(5,2),
    PRIMARY KEY (line_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);


CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT,
    status_value VARCHAR(20),
    PRIMARY KEY (status_id)
);


CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT,
    order_id INT,
    status_id INT,
    status_date DATETIME,
    PRIMARY KEY (history_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);




--sample data
-- 1. BOOK LANGUAGE (5 sample entries)
INSERT INTO book_language(language_code, language_name) VALUES 
('ENG','English'),
('SPA','Spanish'),
('FRE','French'),
('GER','German'),
('ITA','Italian');

-- 2. PUBLISHER (5 sample entries)
INSERT INTO publisher(publisher_name) VALUES 
('Penguin Books'),
('HarperCollins'),
('Simon & Schuster'),
('Random House'),
('Hachette');

-- 3. AUTHOR (10 sample entries)
INSERT INTO author(author_name) VALUES 
('Stephen King'),
('J.K. Rowling'),
('George R.R. Martin'),
('Agatha Christie'),
('J.R.R. Tolkien'),
('Neil Gaiman'),
('Dan Brown'),
('Ernest Hemingway'),
('Mark Twain'),
('Jane Austen');

-- 4. BOOK (20 sample entries)
INSERT INTO book(isbn13, title, num_pages, publication_date, language_id, publisher_id) VALUES
('9780451169525', 'The Shining', 447, '1977-01-28', 1, 1),
('9780747532743', 'Harry Potter and the Philosopher''s Stone', 223, '1997-06-26', 1, 2),
('9780553103540', 'A Game of Thrones', 694, '1996-08-06', 1, 3),
('9780007120842', 'Murder on the Orient Express', 256, '1934-01-01', 1, 4),
('9780618640157', 'The Hobbit', 310, '1937-09-21', 1, 5),
('9780060558123', 'American Gods', 465, '2001-06-19', 1, 2),
('9780307474278', 'The Da Vinci Code', 689, '2003-03-18', 1, 3),
('9780684801223', 'The Old Man and the Sea', 127, '1952-09-01', 1, 1),
('9780486280615', 'The Adventures of Tom Sawyer', 274, '1876-06-01', 1, 4),
('9780141439518', 'Pride and Prejudice', 279, '1813-01-28', 1, 5),
('9780451169532', 'Doctor Sleep', 531, '2013-11-04', 1, 1),
('9780747538486', 'Harry Potter and the Chamber of Secrets', 251, '1998-07-02', 1, 2),
('9780553573428', 'A Clash of Kings', 768, '1998-11-16', 1, 3),
('9780007120859', 'Death on the Nile', 333, '1937-11-01', 1, 4),
('9780618002250', 'The Lord of the Rings: The Fellowship of the Ring', 423, '1954-07-29', 1, 5),
('9780061120084', 'Coraline', 162, '2002-08-02', 1, 2),
('9780307474285', 'Angels & Demons', 616, '2000-05-01', 1, 3),
('9780684830490', 'For Whom the Bell Tolls', 480, '1940-10-21', 1, 1),
('9780486280646', 'The Adventures of Huckleberry Finn', 366, '1884-12-10', 1, 4),
('9780141439600', 'Emma', 474, '1815-12-23', 1, 5);

-- 5. BOOK_AUTHOR (Mapping books to authors, 20 entries)
INSERT INTO book_author(book_id, author_id) VALUES
(1, 1),   -- The Shining -> Stephen King
(2, 2),   -- Harry Potter 1 -> J.K. Rowling
(3, 3),   -- A Game of Thrones -> George R.R. Martin
(4, 4),   -- Murder on the Orient Express -> Agatha Christie
(5, 5),   -- The Hobbit -> J.R.R. Tolkien
(6, 6),   -- American Gods -> Neil Gaiman
(7, 7),   -- The Da Vinci Code -> Dan Brown
(8, 8),   -- The Old Man and the Sea -> Ernest Hemingway
(9, 9),   -- Tom Sawyer -> Mark Twain
(10, 10), -- Pride and Prejudice -> Jane Austen
(11, 1),  -- Doctor Sleep -> Stephen King
(12, 2),  -- Harry Potter 2 -> J.K. Rowling
(13, 3),  -- A Clash of Kings -> George R.R. Martin
(14, 4),  -- Death on the Nile -> Agatha Christie
(15, 5),  -- LOTR: Fellowship -> J.R.R. Tolkien
(16, 6),  -- Coraline -> Neil Gaiman
(17, 7),  -- Angels & Demons -> Dan Brown
(18, 8),  -- For Whom the Bell Tolls -> Ernest Hemingway
(19, 9),  -- Huck Finn -> Mark Twain
(20, 10); -- Emma -> Jane Austen

-- 6. COUNTRY (5 sample entries)
INSERT INTO country(country_name) VALUES
('United States'),
('United Kingdom'),
('Canada'),
('Australia'),
('Germany');

-- 7. ADDRESS (10 sample entries)
INSERT INTO address(street_number, street_name, city, country_id) VALUES
('101', 'Main St', 'Springfield', 1),
('202', 'Oak Ave', 'Shelbyville', 2),
('303', 'Maple Dr', 'Capital City', 3),
('404', 'Pine Rd', 'Gotham', 4),
('505', 'Elm St', 'Metropolis', 5),
('606', 'Cedar Ln', 'Smallville', 1),
('707', 'Birch Blvd', 'Star City', 2),
('808', 'Fir Ave', 'Coast City', 3),
('909', 'Spruce St', 'Central City', 4),
('1010', 'Willow Way', 'Bludhaven', 5);

-- 8. ADDRESS_STATUS (2 sample entries)
INSERT INTO address_status(address_status) VALUES
('Current'),
('Old');

-- 9. CUSTOMER (10 sample entries)
INSERT INTO customer(first_name, last_name, email) VALUES
('Alice', 'Smith', 'alice.smith@example.com'),
('Bob', 'Johnson', 'bob.johnson@example.com'),
('Carol', 'Williams', 'carol.williams@example.com'),
('David', 'Brown', 'david.brown@example.com'),
('Eve', 'Jones', 'eve.jones@example.com'),
('Frank', 'Garcia', 'frank.garcia@example.com'),
('Grace', 'Miller', 'grace.miller@example.com'),
('Heidi', 'Davis', 'heidi.davis@example.com'),
('Ivan', 'Rodriguez', 'ivan.rodriguez@example.com'),
('Judy', 'Martinez', 'judy.martinez@example.com');

-- 10. CUSTOMER_ADDRESS (linking customers to addresses, one per customer)
INSERT INTO customer_address(customer_id, address_id, status_id) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1),
(10, 10, 1);

-- 11. SHIPPING_METHOD (3 sample entries)
INSERT INTO shipping_method(method_name, cost) VALUES
('Standard', 5.00),
('Express', 10.00),
('Overnight', 20.00);

-- 12. ORDER_STATUS (3 sample entries)
INSERT INTO order_status(status_value) VALUES
('Pending'),
('Shipped'),
('Delivered');

-- 13. CUST_ORDER (10 sample entries)
INSERT INTO cust_order(order_date, customer_id, dest_address_id, shipping_method_id) VALUES
('2024-01-01 10:00:00', 1, 1, 1),
('2024-01-02 11:30:00', 2, 2, 2),
('2024-01-03 12:15:00', 3, 3, 1),
('2024-01-04 09:45:00', 4, 4, 3),
('2024-01-05 14:00:00', 5, 5, 2),
('2024-01-06 16:20:00', 6, 6, 1),
('2024-01-07 10:50:00', 7, 7, 2),
('2024-01-08 13:30:00', 8, 8, 1),
('2024-01-09 15:15:00', 9, 9, 3),
('2024-01-10 11:00:00', 10, 10, 1);

-- 14. ORDER_LINE (10 sample entries)
INSERT INTO order_line(order_id, book_id, price) VALUES
(1, 2, 19.99),
(1, 4, 9.99),
(2, 3, 25.50),
(3, 5, 15.75),
(4, 7, 12.00),
(5, 1, 18.00),
(6, 10, 14.25),
(7, 6, 20.00),
(8, 8, 8.50),
(9, 9, 11.00);

-- 15. ORDER_HISTORY (10 sample entries)
INSERT INTO order_history(order_id, status_id, status_date) VALUES
(1, 1, '2024-01-01 10:05:00'),
(1, 2, '2024-01-01 12:00:00'),
(2, 1, '2024-01-02 11:35:00'),
(2, 2, '2024-01-02 14:00:00'),
(3, 1, '2024-01-03 12:20:00'),
(4, 1, '2024-01-04 09:50:00'),
(4, 3, '2024-01-05 08:00:00'),
(5, 1, '2024-01-05 14:05:00'),
(5, 2, '2024-01-05 16:00:00'),
(6, 1, '2024-01-06 16:25:00');


-- Create a new user
CREATE USER 'bookstore_user'@'localhost' IDENTIFIED BY 'strong_password';

-- Grant the necessary privileges on the bookstore database
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.* TO 'bookstore_user'@'localhost';

-- Flush privileges to ensure that the changes take effect
FLUSH PRIVILEGES;

