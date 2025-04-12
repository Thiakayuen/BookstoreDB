# Bookstore Database Management System

## Project Overview
This project implements a comprehensive database management system for a bookstore using MySQL. The system is designed to handle all aspects of bookstore operations, including inventory management, customer relations, order processing, and sales analysis.

## Features
- **Comprehensive Book Management**
  - Track book details, authors, publishers, and languages
  - Manage book categories and conditions
  - Handle inventory levels and stock alerts
  - Support book reviews and ratings

- **Customer Management**
  - Customer profiles and contact information
  - Multiple shipping addresses per customer
  - Loyalty program with points system
  - Membership tiers (Standard, Silver, Gold, Platinum)

- **Order Processing**
  - Complete order management system
  - Multiple payment methods
  - Various shipping options
  - Order status tracking and history

- **Advanced Features**
  - Inventory alerts for low stock
  - Book condition tracking with pricing adjustments
  - Customer review system
  - Sales analytics and reporting

## Database Schema
The database consists of the following main tables:

### Core Tables
- `books`: Stores book information including title, ISBN, price, and stock
- `author`: Contains author details
- `book_author`: Manages many-to-many relationship between books and authors
- `publisher`: Publisher information
- `book_language`: Available languages for books

### Customer Management
- `customer`: Customer profiles and loyalty information
- `customer_address`: Customer shipping addresses
- `address`: Address details
- `country`: Country information
- `address_status`: Address status types

### Order Management
- `cust_order`: Order details
- `order_line`: Individual items in orders
- `order_status`: Order status types
- `order_history`: Order status changes
- `shipping_method`: Available shipping options
- `payment_method`: Customer payment methods

### Additional Features
- `book_category`: Book categorization
- `book_condition`: Book condition types
- `book_review`: Customer reviews and ratings
- `inventory_alert`: Stock level alerts

## Setup Instructions

### Prerequisites
- MySQL Server
- MySQL Workbench or similar database management tool
- Basic understanding of SQL

### Installation
1. Clone the repository
2. Open MySQL and create a new database:
   ```sql
   CREATE DATABASE bookstore;
   USE bookstore;
   ```
3. Run the `bookstore.sql` script to create all tables and sample data
4. Run the `bookstore_queries.sql` script to test the database with example queries

## Example Queries
The project includes a comprehensive set of example queries demonstrating various features:

1. **Inventory Management**
   ```sql
   SELECT b.title, b.quantity, b.minimum_stock_level
   FROM books b
   WHERE b.quantity <= b.minimum_stock_level;
   ```

2. **Customer Loyalty Program**
   ```sql
   SELECT c.first_name, c.last_name, c.loyalty_points, c.membership_level
   FROM customer c
   ORDER BY c.loyalty_points DESC
   LIMIT 5;
   ```

3. **Sales Analysis**
   ```sql
   SELECT bc.category_name,
          COUNT(DISTINCT ol.order_id) AS total_orders,
          SUM(ol.quantity) AS total_books_sold
   FROM book_category bc
   JOIN books b ON bc.id = b.category_id
   JOIN order_line ol ON b.id = ol.book_id
   GROUP BY bc.id;
   ```

## Security Features
- User authentication and authorization
- Secure payment information storage
- Data encryption for sensitive information
- Access control for different user roles

## Best Practices Implemented
- Proper indexing for performance optimization
- Referential integrity with foreign keys
- Data validation and constraints
- Normalized database design
- Comprehensive error handling

## Project Structure
```
bookstore/
├── bookstore.sql          # Database schema and sample data
├── bookstore_queries.sql  # Example queries
└── README.md             # Project documentation
```

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- MySQL Documentation
- Database Design Best Practices
- Bookstore Management Systems
