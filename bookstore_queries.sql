-- Example Queries for Bookstore Database

-- 1. Book Inventory Management
-- Find books with low stock (below minimum stock level)
SELECT b.title, b.quantity, b.minimum_stock_level, 
       CASE 
           WHEN b.quantity <= b.minimum_stock_level THEN 'Low Stock'
           ELSE 'Stock OK'
       END AS stock_status
FROM books b
WHERE b.quantity <= b.minimum_stock_level;

-- 2. Customer Loyalty Program
-- Get top customers by loyalty points
SELECT c.first_name, c.last_name, c.loyalty_points, c.membership_level,
       COUNT(o.id) AS total_orders,
       SUM(o.total_amount) AS total_spent
FROM customer c
LEFT JOIN cust_order o ON c.id = o.customer_id
GROUP BY c.id
ORDER BY c.loyalty_points DESC
LIMIT 5;

-- 3. Book Reviews and Ratings
-- Get average rating and review count for each book
SELECT b.title, 
       AVG(br.rating) AS average_rating,
       COUNT(br.id) AS review_count,
       SUM(CASE WHEN br.is_verified_purchase THEN 1 ELSE 0 END) AS verified_reviews
FROM books b
LEFT JOIN book_review br ON b.id = br.book_id
GROUP BY b.id
ORDER BY average_rating DESC;

-- 4. Sales Analysis by Category
-- Get sales statistics by book category
SELECT bc.category_name,
       COUNT(DISTINCT ol.order_id) AS total_orders,
       SUM(ol.quantity) AS total_books_sold,
       SUM(ol.quantity * ol.price * (1 - ol.discount_percentage/100)) AS total_revenue
FROM book_category bc
JOIN books b ON bc.id = b.category_id
JOIN order_line ol ON b.id = ol.book_id
GROUP BY bc.id
ORDER BY total_revenue DESC;

-- 5. Customer Purchase History
-- Get detailed purchase history for a specific customer
SELECT c.first_name, c.last_name,
       o.order_date,
       b.title,
       ol.quantity,
       ol.price,
       o.discount_amount,
       o.total_amount,
       os.status_name AS order_status
FROM customer c
JOIN cust_order o ON c.id = o.customer_id
JOIN order_line ol ON o.id = ol.order_id
JOIN books b ON ol.book_id = b.id
JOIN order_status os ON o.status_id = os.id
WHERE c.id = 1
ORDER BY o.order_date DESC;

-- 6. Book Condition Analysis
-- Analyze books by condition and their impact on pricing
SELECT bc.condition_name,
       COUNT(b.id) AS total_books,
       AVG(b.price * (1 - bc.discount_percentage/100)) AS average_discounted_price,
       SUM(b.quantity) AS total_stock
FROM book_condition bc
JOIN books b ON bc.id = b.condition_id
GROUP BY bc.id
ORDER BY average_discounted_price DESC;

-- 7. Shipping Analysis
-- Analyze shipping methods and their usage
SELECT sm.method_name,
       COUNT(o.id) AS total_orders,
       AVG(sm.estimated_delivery_days) AS avg_delivery_days,
       SUM(o.total_amount) AS total_revenue
FROM shipping_method sm
JOIN cust_order o ON sm.id = o.shipping_method_id
GROUP BY sm.id
ORDER BY total_orders DESC;

-- 8. Payment Method Analysis
-- Analyze customer payment preferences
SELECT pm.payment_type,
       COUNT(DISTINCT pm.customer_id) AS total_customers,
       COUNT(o.id) AS total_orders,
       SUM(o.total_amount) AS total_revenue
FROM payment_method pm
JOIN cust_order o ON pm.id = o.payment_method_id
GROUP BY pm.payment_type
ORDER BY total_revenue DESC;

-- 9. Inventory Alerts
-- Get current inventory alerts
SELECT b.title,
       ia.alert_type,
       ia.alert_date,
       b.quantity,
       b.minimum_stock_level
FROM inventory_alert ia
JOIN books b ON ia.book_id = b.id
WHERE ia.is_resolved = FALSE
ORDER BY ia.alert_date DESC;

-- 10. Customer Address Analysis
-- Analyze customer addresses by country
SELECT co.country_name,
       COUNT(DISTINCT ca.customer_id) AS total_customers,
       COUNT(DISTINCT a.id) AS total_addresses
FROM country co
JOIN address a ON co.id = a.country_id
JOIN customer_address ca ON a.id = ca.address_id
GROUP BY co.id
ORDER BY total_customers DESC;

-- 11. Book Search with Multiple Criteria
-- Search books with multiple filters
SELECT b.title,
       a.first_name,
       a.last_name,
       bc.category_name,
       bl.language_name,
       p.publisher_name,
       b.price,
       b.quantity
FROM books b
JOIN book_author ba ON b.id = ba.book_id
JOIN author a ON ba.author_id = a.id
JOIN book_category bc ON b.category_id = bc.id
JOIN book_language bl ON b.language_id = bl.id
JOIN publisher p ON b.publisher_id = p.id
WHERE b.price BETWEEN 10 AND 25
  AND b.quantity > 0
  AND bc.category_name = 'Fantasy'
ORDER BY b.price;

-- 12. Order Status Tracking
-- Track order status changes over time
SELECT o.id AS order_id,
       c.first_name,
       c.last_name,
       os.status_name,
       oh.status_date,
       oh.notes
FROM cust_order o
JOIN customer c ON o.customer_id = c.id
JOIN order_history oh ON o.id = oh.order_id
JOIN order_status os ON oh.status_id = os.id
ORDER BY o.id, oh.status_date;

-- 13. Customer Loyalty Points History
-- Track customer loyalty points changes
SELECT c.first_name,
       c.last_name,
       o.order_date,
       o.loyalty_points_earned,
       o.loyalty_points_used,
       (o.loyalty_points_earned - o.loyalty_points_used) AS net_points_change,
       c.loyalty_points AS current_points
FROM customer c
JOIN cust_order o ON c.id = o.customer_id
ORDER BY c.id, o.order_date;

-- 14. Book Reviews with Customer Details
-- Get detailed book reviews with customer information
SELECT b.title,
       c.first_name,
       c.last_name,
       br.rating,
       br.review_text,
       br.review_date,
       CASE WHEN br.is_verified_purchase THEN 'Yes' ELSE 'No' END AS verified_purchase
FROM book_review br
JOIN books b ON br.book_id = b.id
JOIN customer c ON br.customer_id = c.id
ORDER BY br.review_date DESC;

-- 15. Sales Performance by Author
-- Analyze sales performance by author
SELECT a.first_name,
       a.last_name,
       COUNT(DISTINCT o.id) AS total_orders,
       SUM(ol.quantity) AS total_books_sold,
       SUM(ol.quantity * ol.price) AS total_revenue
FROM author a
JOIN book_author ba ON a.id = ba.author_id
JOIN books b ON ba.book_id = b.id
JOIN order_line ol ON b.id = ol.book_id
JOIN cust_order o ON ol.order_id = o.id
GROUP BY a.id
ORDER BY total_revenue DESC; 