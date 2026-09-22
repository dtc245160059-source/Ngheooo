-- =============================================================================
-- PAYFLOW E-WALLET DATABASE OPTIMIZATION SCRIPT
-- Role: Database Performance Engineer
-- Task: Resolve Full Table Scan Bottleneck on Transactions (5M rows)
-- =============================================================================

CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

-- -----------------------------------------------------------------------------
-- 1. DDL & Setup Cấu trúc bảng
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS Transactions;

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
);

-- -----------------------------------------------------------------------------
-- 2. ĐÁNH GIÁ CÂU TRUY VẤN CŨ (Non-SARGable - Trạng thái chưa tối ưu)
-- Nguyên nhân gây chậm: Bọc hàm YEAR() và MONTH() trên cột created_at 
-- khiến MySQL không thể dùng Index B-Tree, dẫn đến Full Table Scan (type = ALL).
-- -----------------------------------------------------------------------------
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND YEAR(created_at) = 2026 
  AND MONTH(created_at) = 6;

-- -----------------------------------------------------------------------------
-- 3. BƯỚC TỐI ƯU HÓA: Tạo Composite Index (B-Tree)
-- Thứ tự: transaction_type (Độ lọc bằng) đứng trước, created_at (Độ lọc Range) đứng sau.
-- -----------------------------------------------------------------------------
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- -----------------------------------------------------------------------------
-- 4. TRUY VẤN ĐÃ TỐI ƯU HÓA (SARGable)
-- Cải tiến: Loại bỏ hàm YEAR/MONTH, chuyển sang so sánh khoảng thời gian [>=, <).
-- Kết quả kì vọng EXPLAIN: type = range hoặc ref, key = idx_type_date, rows giảm mạnh.
-- -----------------------------------------------------------------------------
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';
