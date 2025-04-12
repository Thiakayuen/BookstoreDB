-- Use the bookstore database
USE bookstoreDB;

-- List all books with their authors and publishers
SELECT b.title, b.isbn, b.price, b.quantity,
       CONCAT(a.first_name, ' ', a.last_name) AS author,
       p.publisher_name,
       bl.language_name
FROM book b
LEFT JOIN book_author ba ON b.id = ba.book_id
LEFT JOIN author a ON ba.author_id = a.id
LEFT JOIN publisher p ON b.publisher_id = p.id
LEFT JOIN book_language bl ON b.language_id = bl.id
ORDER BY b.title;

-- Find books by a specific author
SELECT b.title, b.isbn, b.price, b.quantity
FROM book b
JOIN book_author ba ON b.id = ba.book_id
JOIN author a ON ba.author_id = a.id
WHERE a.first_name = 'J.K.' AND a.last_name = 'Rowling';

-- 2. Inventory Management Queries

-- Check low inventory (books with quantity less than 10)
SELECT b.title, b.quantity, p.publisher_name
FROM book b
JOIN publisher p ON b.publisher_id = p.id
WHERE b.quantity < 10
ORDER BY b.quantity;

-- Get total inventory value
SELECT SUM(price * quantity) AS total_inventory_value
FROM book;

-- 3. Customer and Order Queries

-- List all customers with their addresses
SELECT c.first_name, c.last_name, c.email, c.phone,
       a.street_address, a.city, a.state, a.postal_code,
       co.country_name, co.country_code
FROM customer c
JOIN customer_address ca ON c.id = ca.customer_id
JOIN address a ON ca.address_id = a.id
JOIN country co ON a.country_id = co.id
WHERE ca.is_default = TRUE;

-- Get customer order history
SELECT c.first_name, c.last_name,
       o.order_date, o.total_amount,
       os.status_name,
       GROUP_CONCAT(b.title SEPARATOR ', ') AS books_ordered
FROM customer c
JOIN cust_order o ON c.id = o.customer_id
JOIN order_status os ON o.status_id = os.id
JOIN order_line ol ON o.id = ol.order_id
JOIN book b ON ol.book_id = b.id
GROUP BY o.id
ORDER BY o.order_date DESC;

-- 4. Sales Analysis Queries

-- Get total sales by author
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

-- Get monthly sales report
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       COUNT(DISTINCT o.id) AS total_orders,
       SUM(o.total_amount) AS total_revenue,
       AVG(o.total_amount) AS average_order_value
FROM cust_order o
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month DESC;

-- 5. Shipping and Delivery Queries

-- Get pending orders with shipping details
SELECT o.id AS order_id,
       c.first_name, c.last_name,
       a.street_address, a.city, a.state, a.postal_code,
       co.country_name,
       sm.method_name, sm.price AS shipping_cost,
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

-- 6. Advanced Analytics Queries

-- Get customer lifetime value
SELECT c.id, c.first_name, c.last_name,
       COUNT(DISTINCT o.id) AS total_orders,
       SUM(o.total_amount) AS total_spent,
       AVG(o.total_amount) AS average_order_value,
       DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS customer_lifetime_days
FROM customer c
JOIN cust_order o ON c.id = o.customer_id
GROUP BY c.id
ORDER BY total_spent DESC;

-- Get popular book combinations (books often bought together)
SELECT b1.title AS book1,
       b2.title AS book2,
       COUNT(*) AS times_bought_together
FROM order_line ol1
JOIN order_line ol2 ON ol1.order_id = ol2.order_id AND ol1.book_id < ol2.book_id
JOIN book b1 ON ol1.book_id = b1.id
JOIN book b2 ON ol2.book_id = b2.id
GROUP BY b1.id, b2.id
HAVING COUNT(*) > 1
ORDER BY times_bought_together DESC;

-- 7. Maintenance and Monitoring Queries

-- Check for orphaned records
SELECT 'book_author' AS table_name, COUNT(*) AS orphaned_records
FROM book_author ba
LEFT JOIN book b ON ba.book_id = b.id
WHERE b.id IS NULL
UNION ALL
SELECT 'customer_address' AS table_name, COUNT(*) AS orphaned_records
FROM customer_address ca
LEFT JOIN customer c ON ca.customer_id = c.id
WHERE c.id IS NULL
UNION ALL
SELECT 'order_line' AS table_name, COUNT(*) AS orphaned_records
FROM order_line ol
LEFT JOIN cust_order o ON ol.order_id = o.id
WHERE o.id IS NULL;

-- Get database statistics
SELECT 
    (SELECT COUNT(*) FROM book) AS total_books,
    (SELECT COUNT(*) FROM author) AS total_authors,
    (SELECT COUNT(*) FROM customer) AS total_customers,
    (SELECT COUNT(*) FROM cust_order) AS total_orders,
    (SELECT SUM(quantity) FROM book) AS total_inventory,
    (SELECT SUM(total_amount) FROM cust_order) AS total_revenue; 