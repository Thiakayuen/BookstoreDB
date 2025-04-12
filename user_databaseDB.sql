-- Create the database
USE bookstoreDB;

-- Create user roles
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'client'@'localhost' IDENTIFIED BY 'client123';
CREATE USER 'employee'@'localhost' IDENTIFIED BY 'employee123';
CREATE USER 'guest'@'localhost' IDENTIFIED BY 'guest123';

-- Grant privileges to admin (full access)
GRANT ALL PRIVILEGES ON bookstoreDB.* TO 'admin'@'localhost';

-- Grant privileges to manager (can manage data but not structure)
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstoreDB.* TO 'client'@'localhost';

-- Grant privileges to staff (limited access)
GRANT INSERT, UPDATE ON bookstoreDB.order_history TO 'employee'@'localhost';

-- Grant privileges to guest (limited access)
GRANT SELECT ON bookstoreDB.* TO 'guest'@'localhost';

-- Flush privileges to apply changes
FLUSH PRIVILEGES; 