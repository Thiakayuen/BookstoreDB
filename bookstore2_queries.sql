SELECT * FROM book_language;

SELECT * FROM publisher;


SELECT b.book_id, b.isbn13, b.title, 
       bl.language_name, 
       p.publisher_name
FROM book b
JOIN book_language bl ON b.language_id = bl.language_id
JOIN publisher p ON b.publisher_id = p.publisher_id;


SELECT b.book_id, b.title, a.author_name
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;


SELECT c.customer_id, c.first_name, c.last_name, 
       a.street_number, a.street_name, a.city, 
       ctr.country_name
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN address a ON ca.address_id = a.address_id
JOIN country ctr ON a.country_id = ctr.country_id;


SELECT p.publisher_name, COUNT(b.book_id) AS book_count
FROM publisher p
JOIN book b ON p.publisher_id = b.publisher_id
GROUP BY p.publisher_name;


SELECT bl.language_name, COUNT(b.book_id) AS num_books
FROM book_language bl
JOIN book b ON bl.language_id = b.language_id
GROUP BY bl.language_name;


SELECT c.first_name, c.last_name, COUNT(o.order_id) AS num_orders
FROM customer c
JOIN cust_order o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;


SELECT * FROM cust_order
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-05';


SELECT o.order_id, o.order_date, c.first_name, c.last_name
FROM cust_order o
JOIN order_history oh ON o.order_id = oh.order_id
JOIN order_status os ON oh.status_id = os.status_id
JOIN customer c ON o.customer_id = c.customer_id
WHERE os.status_value = 'Pending';

---advanced queries
SELECT b.title,
       GROUP_CONCAT(a.author_name SEPARATOR ', ') AS authors
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id
GROUP BY b.book_id;


SELECT p.publisher_name, COUNT(b.book_id) AS book_count
FROM publisher p
JOIN book b ON p.publisher_id = b.publisher_id
GROUP BY p.publisher_name
ORDER BY book_count DESC
LIMIT 1;


SELECT o.order_id, o.order_date,
       c.first_name, c.last_name,
       GROUP_CONCAT(CONCAT(b.title, ' (', ol.price, ')') SEPARATOR ', ') AS order_items,
       (SELECT SUM(ol2.price) FROM order_line ol2 WHERE ol2.order_id = o.order_id) AS total_price
FROM cust_order o
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_line ol ON o.order_id = ol.order_id
JOIN book b ON ol.book_id = b.book_id
GROUP BY o.order_id;


SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM cust_order
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);


SELECT oh.order_id, oh.status_date, os.status_value
FROM order_history oh
JOIN order_status os ON oh.status_id = os.status_id
WHERE oh.status_date IN (
    SELECT MAX(status_date)
    FROM order_history
    GROUP BY order_id
);
