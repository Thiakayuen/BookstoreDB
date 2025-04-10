CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE books (id PRIMARY KEY auto increment,
author VARCHAR(100),
title VARCHAR(100),
price DECIMAL(5,2),
quantity INT);

INSERT INTO books (author, title, price, quantity) VALUES
('J.K. Rowling', 'Harry Potter and the Philosopher''s Stone', 19.99, 100);
