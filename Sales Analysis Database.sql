-- ===============================
-- 1️⃣ CREATE DATABASE AND USE IT
-- ===============================

CREATE DATABASE SalesAnalysisDB;
USE SalesAnalysisDB;

-- ===============================
-- 2️⃣ CREATE TABLES
-- ===============================

-- Customers Table
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    age INT,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other'))
);

-- Products Table
CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- Sales Table
CREATE TABLE sales (
    sale_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    sale_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ===============================
-- 3️⃣ INSERT SAMPLE DATA
-- ===============================

-- Insert into Customers Table
INSERT INTO customers (name, location, age, gender) 
VALUES 
('John Doe', 'New York', 30, 'Male'),
('Jane Smith', 'Los Angeles', 28, 'Female'),
('Alice Brown', 'Chicago', 35, 'Female'),
('Bob Johnson', 'Houston', 40, 'Male'),
('Charlie Lee', 'San Francisco', 25, 'Other');

-- Insert into Products Table
INSERT INTO products (name, category, price, stock_quantity) 
VALUES 
('Laptop', 'Electronics', 1000.00, 50),
('Smartphone', 'Electronics', 700.00, 100),
('Headphones', 'Accessories', 150.00, 200),
('Desk Chair', 'Furniture', 250.00, 30),
('Coffee Maker', 'Appliances', 80.00, 75);

-- Insert into Sales Table
INSERT INTO sales (customer_id, product_id, quantity, total_price, sale_date) 
VALUES 
(1, 2, 1, 700.00, '2024-03-20 10:30:00'),
(2, 1, 2, 2000.00, '2024-03-21 14:00:00'),
(3, 3, 3, 450.00, '2024-03-22 09:15:00'),
(4, 4, 1, 250.00, '2024-03-23 16:45:00'),
(5, 5, 2, 160.00, '2024-03-24 12:00:00');

-- ===============================
-- 4️⃣ DATA ANALYSIS QUERIES
-- ===============================

-- Total Sales Revenue
SELECT SUM(total_price) AS total_revenue FROM sales;

-- Total Sales per Product
SELECT 
    p.name AS product_name, 
    SUM(s.quantity) AS total_units_sold, 
    SUM(s.total_price) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sales DESC;

-- Sales by Customer
SELECT 
    c.name AS customer_name, 
    COUNT(s.sale_id) AS total_purchases, 
    SUM(s.total_price) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- Best-Selling Product
SELECT TOP 1 
    p.name AS best_selling_product, 
    SUM(s.quantity) AS total_units_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.name
ORDER BY total_units_sold DESC;

-- Sales Trends Over Time (Monthly)
SELECT 
    FORMAT(s.sale_date, 'yyyy-MM') AS month, 
    SUM(s.total_price) AS total_sales
FROM sales s
GROUP BY FORMAT(s.sale_date, 'yyyy-MM')
ORDER BY month;

-- Low Stock Products (Less than 10 units)
SELECT name, stock_quantity 
FROM products 
WHERE stock_quantity < 10;

-- Most Loyal Customers (Frequent Buyers)
SELECT 
    c.name AS customer_name, 
    COUNT(s.sale_id) AS total_purchases
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_purchases DESC;

-- Average Spending per Customer
SELECT AVG(total_price) AS avg_spending_per_sale FROM sales;

-- Sales by Customer Location
SELECT 
    c.location, 
    SUM(s.total_price) AS total_sales
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.location
ORDER BY total_sales DESC;
