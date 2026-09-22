-- =============================================================================
-- AUTORIDE DATABASE OPTIMIZATION SCRIPT
-- Role: Data Architect
-- Description: DDL upgrades and DML simulation for rental workflow & fee recovery
-- =============================================================================

CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- -----------------------------------------------------------------------------
-- BƯỚC 1: KHỞI TẠO BẢNG CARS (DANH MỤC XE)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

-- -----------------------------------------------------------------------------
-- BƯỚC 2: CẤU TRÚC LẠI BẢNG RENTALS (BỔ SUNG THUỘC TÍNH TÀI CHÍNH & TRẠNG THÁI)
-- -----------------------------------------------------------------------------
-- Lỗi legacy: status VARCHAR(50) -> Đổi sang ENUM chuẩn hóa
-- Lỗi legacy: Khống có cột tài chính -> Thêm security_deposit, late_fee, damage_fee kiểu DECIMAL
CREATE TABLE IF NOT EXISTS Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME NULL,
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'BOOKED',
    security_deposit DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    late_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    damage_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE RESTRICT
);

-- -----------------------------------------------------------------------------
-- BƯỚC 3: TẠO BẢNG INSPECTIONS (BIÊN BẢN KIỂM TRA XE)
-- -----------------------------------------------------------------------------
-- Khắc phục Lỗi 3: Lưu trữ chi tiết sự cố và tình trạng xe khi trả
CREATE TABLE IF NOT EXISTS Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
);

-- =============================================================================
-- BƯỚC 4: KỊCH BẢN MÔ PHỎNG VẬN HÀNH (DML SIMULATION)
-- =============================================================================

-- 1. Thêm xe mẫu vào hệ thống
INSERT INTO Cars (model_name, license_plate) 
VALUES ('Toyota Camry 2023', '30H-888.99');

-- 2. Khách hàng "Nguyen Van A" đặt và nhận xe (Cọc 10.000.000 VNĐ, Trạng thái: ACTIVE)
INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit)
VALUES (1, 'Nguyen Van A', '2026-09-20 08:00:00', 'ACTIVE', 10000000.00);

-- 3. Khách trả xe: Nhân viên kiểm tra phát hiện vỡ đèn pha trái -> Tạo biên bản
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (1, '2026-09-22 10:00:00', 'Vỡ đèn pha trái', 'Tran Van Inspector');

-- 4. Cập nhật hợp đồng: Trạng thái COMPLETED, tính phí hư hỏng 2.000.000 VNĐ, phạt trễ 0 VNĐ
UPDATE Rentals 
SET return_date = '2026-09-22 10:00:00',
    status = 'COMPLETED',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = 1;

-- 5. Truy vấn tính số tiền cọc thực tế hoàn trả cho khách hàng (Refund Calculation)
SELECT 
    r.rental_id AS 'Mã Hợp Đồng',
    r.customer_name AS 'Tên Khách Hàng',
    c.license_plate AS 'Biển Số Xe',
    r.status AS 'Trạng Thái',
    r.security_deposit AS 'Tiền Cọc (VNĐ)',
    r.late_fee AS 'Phí Trễ (VNĐ)',
    r.damage_fee AS 'Phí Hư Hỏng (VNĐ)',
    i.damage_description AS 'Ghi Chú Hư Hỏng',
    (r.security_deposit - COALESCE(r.late_fee, 0) - COALESCE(r.damage_fee, 0)) AS 'Tiền Hoàn Trả Khách (VNĐ)'
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 1;
