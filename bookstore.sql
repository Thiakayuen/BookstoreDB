CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE books (id PRIMARY KEY auto increment,
author VARCHAR(100),
title VARCHAR(100),
price DECIMAL(5,2),
quantity INT);

INSERT INTO books (author, title, price, quantity) VALUES
('J.K. Rowling', 'Harry Potter and the Philosopher''s Stone', 19.99, 100);



CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

INSERT INTO book_author (book_id, author_id) VALUES
(1, 1);





