
## 🧾 Project Overview
This project implements a comprehensive database management system for a bookstore using **MySQL**. It supports all major bookstore operations, including inventory management, customer profiles, order processing, and analytics.

---

## 🚀 Features

### 📦 Book Management
- Track book details, authors, publishers, and languages
- Handle inventory levels with low-stock alerts
- Support for book reviews and condition-based pricing

### 👤 Customer Management
- Maintain customer profiles and contact info
- Support multiple addresses per customer
- Address status tracking (Current, Previous, Business, etc.)

### 🛒 Order Processing
- Full order lifecycle management
- Multiple payment and shipping methods
- Order tracking and history

### 📊 Advanced Features
- Inventory alerts for low stock
- Book condition tracking
- Customer reviews and ratings
- Sales analytics and reporting

---

## 🗂️ Database Schema

### 📘 Core Tables
- `book`: Stores book information (title, ISBN, price, stock)
- `author`: Author details
- `book_author`: Many-to-many link between books and authors
- `publisher`, `book_language`

### 👥 Customer Management
- `customer`, `customer_address`, `address`, `country`
- `address_status`: Types of address (e.g., current, previous)

### 🧾 Order Management
- `cust_order`: Orders
- `order_line`: Items per order
- `order_status`, `order_history`
- `shipping_method`

---

## 🧱 ER Diagram

![ERD Diagram](https://github.com/user-attachments/assets/e94c367c-da66-4e1e-8f97-af229203b750)


## ⚙️ Setup Instructions

### Prerequisites
- MySQL Server
- MySQL Workbench or XAMPP
- Basic SQL knowledge

### Installation
```sql
CREATE DATABASE bookstore;
USE bookstore;
