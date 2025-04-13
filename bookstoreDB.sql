-- Create the bookstoreDB database  
CREATE DATABASE bookstoreDB;

-- Use the bookstore database
USE bookstoreDB;

-- 2. Tables without dependencies
CREATE TABLE country (
    id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL,
    country_code VARCHAR(10)
) ENGINE = InnoDB;

CREATE TABLE order_status (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(100) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE shipping_method (
    id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE book_language (
    id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(100) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE publisher (
    id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    email VARCHAR(100)
) ENGINE = InnoDB;

CREATE TABLE author (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
) ENGINE = InnoDB;

-- 3. Tables that depend on above
CREATE TABLE address (
    id INT PRIMARY KEY AUTO_INCREMENT,
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(id)
) ENGINE = InnoDB;

CREATE TABLE customer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20)
) ENGINE = InnoDB;

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
) ENGINE = InnoDB;

-- Create address_status table
CREATE TABLE address_status (
    id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

-- 4. Tables with higher-level dependencies
CREATE TABLE customer_address (
    id INT PRIMARY KEY AUTO_INCREMENT,
    address_status_id INT,
    customer_id INT,
    address_id INT,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (address_status_id) REFERENCES address_status(id),
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (address_id) REFERENCES address(id)
) ENGINE = InnoDB;

CREATE TABLE cust_order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_id INT,
    shipping_method_id INT,
    shipping_address_id INT,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (status_id) REFERENCES order_status(id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(id),
    FOREIGN KEY (shipping_address_id) REFERENCES customer_address(id)
) ENGINE = InnoDB;

CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(id),
    FOREIGN KEY (author_id) REFERENCES author(id)
) ENGINE = InnoDB;

CREATE TABLE order_line (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES cust_order(id),
    FOREIGN KEY (book_id) REFERENCES book(id)
) ENGINE = InnoDB;

-- Create order_history table
CREATE TABLE order_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    changed_by VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES cust_order(id),
    FOREIGN KEY (status_id) REFERENCES order_status(id)
) ENGINE = InnoDB;

-- Insert data into tables
-- Insert into country table (matches CREATE TABLE)
INSERT INTO country (country_name, country_code)
VALUES ('United States', 'USA'),
    ('United Kingdom', 'GBR'),
    ('Canada', 'CAN'),
    ('Australia', 'AUS'),
    ('Germany', 'DEU');

-- Insert into order_status table (matches CREATE TABLE)
INSERT INTO order_status (status_name)
VALUES ('Pending'),
    ('Processing'),
    ('Shipped'),
    ('Delivered'),
    ('Cancelled');

-- Insert into shipping_method table (matches CREATE TABLE)
INSERT INTO shipping_method (method_name, price)
VALUES ('Standard Shipping', 5.99),
    ('Express Shipping', 12.99),
    ('Overnight Shipping', 24.99),
    ('International Shipping', 19.99);

-- Insert into book_language table (matches CREATE TABLE)
INSERT INTO book_language (language_name)
VALUES ('English'),
    ('Spanish'),
    ('French'),
    ('German'),
    ('Italian');

-- Insert into publisher table (matches CREATE TABLE)
INSERT INTO publisher (publisher_name, address, email)
VALUES (
        'Penguin Books',
        '80 Strand, London WC2R 0RL, UK',
        'info@penguin.co.uk'
    ),
    (
        'HarperCollins',
        '195 Broadway, New York, NY 10007, USA',
        'contact@harpercollins.com'
    ),
    (
        'Random House',
        '1745 Broadway, New York, NY 10019, USA',
        'info@randomhouse.com'
    ),
    (
        'Simon & Schuster',
        '1230 Avenue of the Americas, New York, NY 10020, USA',
        'contact@simonandschuster.com'
    ),
    (
        'Macmillan',
        '120 Broadway, New York, NY 10271, USA',
        'info@macmillan.com'
    );

-- Insert into author table (matches CREATE TABLE)
INSERT INTO author (first_name, last_name)
VALUES ('J.K.', 'Rowling'),
    ('George R.R.', 'Martin'),
    ('Stephen', 'King'),
    ('Agatha', 'Christie'),
    ('Ernest', 'Hemingway');

-- Insert into address table (matches CREATE TABLE)
INSERT INTO address (
        street_address,
        city,
        state,
        postal_code,
        country_id
    )
VALUES ('123 Main St', 'New York', 'NY', '10001', 1),
    ('456 Oxford St', 'London', NULL, 'W1D 1BS', 2),
    ('789 Queen St', 'Toronto', 'ON', 'M5H 2N2', 3),
    ('321 Collins St', 'Melbourne', 'VIC', '3000', 4),
    ('654 Friedrichstr', 'Berlin', NULL, '10117', 5);

-- Insert into customer table (matches CREATE TABLE)
INSERT INTO customer (first_name, last_name, email, phone)
VALUES (
        'John',
        'Doe',
        'john.doe@example.com',
        '+1-212-555-1234'
    ),
    (
        'Jane',
        'Smith',
        'jane.smith@example.com',
        '+44-20-7123-4567'
    ),
    (
        'Robert',
        'Johnson',
        'robert.j@example.com',
        '+1-416-555-7890'
    ),
    (
        'Emily',
        'Brown',
        'emily.b@example.com',
        '+61-3-9876-5432'
    ),
    (
        'Michael',
        'Schmidt',
        'm.schmidt@example.com',
        '+49-30-1234-5678'
    );

-- Insert into book table (matches CREATE TABLE)
INSERT INTO book (
        title,
        isbn,
        price,
        quantity,
        language_id,
        publisher_id,
        publication_date
    )
VALUES (
        'Harry Potter and the Philosopher''s Stone',
        '9780747532743',
        19.99,
        50,
        1,
        1,
        '1997-06-26'
    ),
    (
        'A Game of Thrones',
        '9780553103540',
        24.99,
        35,
        1,
        2,
        '1996-08-01'
    ),
    (
        'The Shining',
        '9780385121675',
        15.99,
        40,
        1,
        3,
        '1977-01-28'
    ),
    (
        'Murder on the Orient Express',
        '9780062073495',
        12.99,
        30,
        1,
        4,
        '1934-01-01'
    ),
    (
        'The Old Man and the Sea',
        '9780684801223',
        10.99,
        25,
        1,
        5,
        '1952-09-01'
    );

-- Insert into customer_address table (matches CREATE TABLE)
INSERT INTO customer_address (
        customer_id,
        address_id,
        is_default,
        address_status_id
    )
VALUES (1, 1, TRUE, 1),
    (1, 2, FALSE, 2),
    (2, 3, TRUE, 1),
    (3, 2, TRUE, 1),
    (3, 1, FALSE, 2);

-- Insert into cust_order table (matches CREATE TABLE)
INSERT INTO cust_order (
        customer_id,
        shipping_address_id,
        shipping_method_id,
        total_amount,
        status_id
    )
VALUES (1, 1, 1, 35.98, 1),
    (2, 2, 2, 49.98, 2),
    (3, 3, 3, 25.98, 3),
    (4, 4, 4, 37.98, 4),
    (5, 5, 1, 15.99, 1);

-- Insert into book_author table (matches CREATE TABLE)
INSERT INTO book_author (book_id, author_id)
VALUES (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- Insert into order_line table (matches CREATE TABLE)
INSERT INTO order_line (order_id, book_id, quantity, price)
VALUES (1, 1, 1, 19.99),
    (1, 3, 1, 15.99),
    (2, 2, 2, 24.99),
    (3, 4, 1, 12.99),
    (3, 5, 1, 10.99),
    (4, 1, 1, 19.99),
    (4, 2, 1, 24.99),
    (5, 3, 1, 15.99);

-- Insert into address_status table (matches CREATE TABLE)
INSERT INTO address_status (status_name, description, is_active)
VALUES (
        'Current',
        'Currently active and valid address',
        TRUE
    ),
    ('Previous', 'Previously used address', TRUE),
    (
        'Temporary',
        'Temporary or short-term address',
        TRUE
    ),
    ('Business', 'Business or work address', TRUE),
    ('Invalid', 'Address is no longer valid', FALSE);

-- Insert into order_history table (matches CREATE TABLE)
INSERT INTO order_history (order_id, status_id, notes, changed_by)
VALUES (1, 1, 'Order received', 'system'),
    (1, 2, 'Payment processed', 'employee1'),
    (1, 3, 'Order shipped', 'employee2'),
    (1, 4, 'Order delivered', 'system'),
    (2, 1, 'Order received', 'system'),
    (2, 2, 'Payment processed', 'employee1');

-- Create roles
CREATE ROLE 'admin';
CREATE ROLE 'client';
CREATE ROLE 'employee';
CREATE ROLE 'guest';
-- Grant privileges to roles

-- Admin has full access
GRANT ALL PRIVILEGES ON bookstoreDB.* TO 'admin';

-- Client can manage data but not structure
GRANT SELECT,
    INSERT,
    UPDATE ON bookstoreDB.* TO 'client';

-- Employee has limited access to order_history table
GRANT INSERT,
    UPDATE ON bookstoreDB.order_history TO 'employee';

-- Guest can only view data
GRANT SELECT ON bookstoreDB.* TO 'guest';

-- Create users
CREATE USER 'thiak_admin' @'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'amos_client' @'localhost' IDENTIFIED BY 'client123';
CREATE USER 'charles_employee' @'localhost' IDENTIFIED BY 'employee123';
CREATE USER 'john_guest' @'localhost' IDENTIFIED BY 'guest123';

-- Assign roles to users
GRANT 'admin' TO 'thiak_admin' @'localhost';
GRANT 'client' TO 'amos_client' @'localhost';
GRANT 'employee' TO 'charles_employee' @'localhost';
GRANT 'guest' TO 'john_guest' @'localhost';

-- Set default roles
SET DEFAULT ROLE 'admin' TO 'thiak_admin' @'localhost';
SET DEFAULT ROLE 'client' TO 'amos_client' @'localhost';
SET DEFAULT ROLE 'employee' TO 'charles_employee' @'localhost';
SET DEFAULT ROLE 'guest' TO 'john_guest' @'localhost';

-- Apply changes
FLUSH PRIVILEGES;

-- List all books with author(s), publisher, and language 
SELECT b.title,
    b.isbn,
    b.price,
    b.quantity,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    p.publisher_name,
    bl.language_name
FROM book b
    LEFT JOIN book_author ba ON b.id = ba.book_id
    LEFT JOIN author a ON ba.author_id = a.id
    LEFT JOIN publisher p ON b.publisher_id = p.id
    LEFT JOIN book_language bl ON b.language_id = bl.id
ORDER BY b.title;

-- Find all books by a specific author
SELECT b.title,
    b.isbn,
    b.price,
    b.quantity
FROM book b
    JOIN book_author ba ON b.id = ba.book_id
    JOIN author a ON ba.author_id = a.id
WHERE a.first_name = 'J.K.'
    AND a.last_name = 'Rowling';

-- Books with low stock (quantity < 10)
SELECT b.title,
    b.quantity,
    p.publisher_name
FROM book b
    JOIN publisher p ON b.publisher_id = p.id
WHERE b.quantity < 10;

-- Totla inventory value
SELECT SUM(b.price * b.quantity) AS total_inventory_value
FROM book b;

-- all customers with default address
SELECT c.first_name,
    c.last_name,
    c.email,
    c.phone,
    a.street_address,
    a.city,
    a.state,
    a.postal_code,
    co.country_name
FROM customer c
    JOIN customer_address ca ON c.id = ca.customer_id
    JOIN address a ON ca.address_id = a.id
    JOIN country co ON a.country_id = co.id
WHERE ca.is_default = TRUE;

-- customer order history
SELECT c.first_name,
    c.last_name,
    o.order_date,
    o.total_amount,
    os.status_name,
    GROUP_CONCAT(b.title SEPARATOR ', ') AS books_ordered
FROM customer c
    JOIN cust_order o ON c.id = o.customer_id
    JOIN order_status os ON o.status_id = os.id
    JOIN order_line ol ON o.id = ol.order_id
    JOIN book b ON ol.book_id = b.id
GROUP BY o.id
ORDER BY o.order_date DESC;

-- total sales by author
SELECT CONCAT(a.first_name, ' ', a.last_name) AS author,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(ol.quantity) AS total_books_sold,
    SUM(ol.quantity * ol.price) AS total_revenue
FROM author a
    JOIN book_author ba ON a.id = ba.author_id
    JOIN book b ON ba.book_id = b.id
    JOIN order_line ol ON b.id = ol.book_id
    JOIN cust_order o ON ol.order_id = o.id
GROUP BY a.id
ORDER BY total_revenue DESC;

-- monthly sales report
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS average_order_value
FROM cust_order o
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month DESC;

-- pending orders with pending status
SELECT o.id AS order_id,
    c.first_name,
    c.last_name,
    a.street_address,
    a.city,
    a.state,
    a.postal_code,
    co.country_name,
    sm.method_name,
    sm.price AS shipping_cost,
    os.status_name
FROM cust_order o
    JOIN customer c ON o.customer_id = c.id
    JOIN customer_address ca ON o.shipping_address_id = ca.id
    JOIN address a ON ca.address_id = a.id
    JOIN country co ON a.country_id = co.id
    JOIN shipping_method sm ON o.shipping_method_id = sm.id
    JOIN order_status os ON o.status_id = os.id
WHERE os.status_name IN ('Pending', 'Processing')
ORDER BY o.order_date;

-- customer lifetime value
SELECT c.id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS customer_lifetime_days
FROM customer c
    JOIN cust_order o ON c.id = o.customer_id
GROUP BY c.id
ORDER BY total_spent DESC;

-- popular books combinations(frequently bought together)
SELECT b1.title AS book1,
    b2.title AS book2,
    COUNT(*) AS times_bought_together
FROM order_line ol1
    JOIN order_line ol2 ON ol1.order_id = ol2.order_id
    AND ol1.book_id < ol2.book_id
    JOIN book b1 ON ol1.book_id = b1.id
    JOIN book b2 ON ol2.book_id = b2.id
GROUP BY b1.id,
    b2.id
HAVING COUNT(*) > 1
ORDER BY times_bought_together DESC;

-- check orphaned records
SELECT 'book_author' AS table_name,
    COUNT(*) AS orphaned_records
FROM book_author ba
    LEFT JOIN book b ON ba.book_id = b.id
WHERE b.id IS NULL
UNION ALL
SELECT 'customer_address',
    COUNT(*)
FROM customer_address ca
    LEFT JOIN customer c ON ca.customer_id = c.id
WHERE c.id IS NULL
UNION ALL
SELECT 'order_line',
    COUNT(*)
FROM order_line ol
    LEFT JOIN cust_order o ON ol.order_id = o.id
WHERE o.id IS NULL;

-- database statistics
SELECT (
        SELECT COUNT(*)
        FROM book
    ) AS total_books,
    (
        SELECT COUNT(*)
        FROM author
    ) AS total_authors,
    (
        SELECT COUNT(*)
        FROM customer
    ) AS total_customers,
    (
        SELECT COUNT(*)
        FROM cust_order
    ) AS total_orders,
    (
        SELECT SUM(quantity)
        FROM book
    ) AS total_inventory,
    (
        SELECT SUM(total_amount)
        FROM cust_order
    ) AS total_revenue;