-- =============================================================================
-- THỰC HÀNH: TẠO VÀ QUẢN LÝ VIEW TRONG MYSQL
-- CSDL MẪU: classicmodels
-- =============================================================================

USE classicmodels;

-- -----------------------------------------------------------------------------
-- BƯỚC 1: TẠO VIEW BAN ĐẦU (customer_views)
-- Trích xuất các cột: customerNumber, customerName, phone từ bảng customers
-- -----------------------------------------------------------------------------
CREATE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- Truy vấn dữ liệu từ bảng ảo customer_views
SELECT * FROM customer_views;


-- -----------------------------------------------------------------------------
-- BƯỚC 2: CẬP NHẬT VIEW (CREATE OR REPLACE VIEW)
-- Thay đổi định nghĩa View: Bổ sung contactFirstName, contactLastName và điều kiện WHERE city = 'Nantes'
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- Kiểm tra lại dữ liệu sau khi cập nhật View
SELECT * FROM customer_views;


-- -----------------------------------------------------------------------------
-- BƯỚC 3: XÓA VIEW (DROP VIEW)
-- Thu hồi View khỏi CSDL khi không còn nhu cầu sử dụng
-- -----------------------------------------------------------------------------
DROP VIEW IF EXISTS customer_views;
