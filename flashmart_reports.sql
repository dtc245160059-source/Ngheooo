-- =============================================================================
-- FLASHMART DATABASE OPTIMIZATION SCRIPT
-- Role: Data Engineer
-- Description: DDL Setup & Corrected SQL Queries for Marketing & Logistics
-- =============================================================================

CREATE DATABASE IF NOT EXISTS flashmart_db;
USE flashmart_db;

-- -----------------------------------------------------------------------------
-- 1. Khởi tạo cấu trúc bảng & Dữ liệu mẫu
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie'); 
INSERT INTO Products VALUES (101, 'Laptop'), (102, 'Mouse'), (103, 'Keyboard'); 
INSERT INTO Orders VALUES (1001, 1, 101), (1002, 1, 102), (1003, 2, 101);

-- =============================================================================
-- 2. Truy vấn tối ưu
-- =============================================================================

-- BÁO CÁO 1: Giám đốc Marketing (Lấy tất cả khách hàng & tổng đơn hàng, kể cả 0 đơn)
-- Giải pháp: Dùng LEFT JOIN để giữ lại Charlie & dùng COUNT(o.order_id) để trả về 0 thay vì 1
SELECT 
    c.customer_id, 
    c.name, 
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- BÁO CÁO 2: Giám đốc Kho vận (Lấy các sản phẩm chưa từng được bán - Anti-Join)
-- Giải pháp: Dùng LEFT JOIN kết hợp WHERE o.order_id IS NULL để lọc sản phẩm mồ côi
SELECT 
    p.product_id, 
    p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
