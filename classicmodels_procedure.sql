-- =============================================================================
-- THỰC HÀNH: STORED PROCEDURE TRONG MYSQL
-- CSDL MẪU: classicmodels
-- =============================================================================

USE classicmodels;

-- -----------------------------------------------------------------------------
-- BƯỚC 1: TẠO STORED PROCEDURE ĐẦU TIÊN (findAllCustomers)
-- -----------------------------------------------------------------------------
-- Thay đổi ký tự kết thúc câu lệnh bằng DELIMITER // để tránh thực thi sớm
DELIMITER //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //

DELIMITER ;

-- -----------------------------------------------------------------------------
-- BƯỚC 2: GỌI STORED PROCEDURE VỪA TẠO
-- -----------------------------------------------------------------------------
CALL findAllCustomers();


-- -----------------------------------------------------------------------------
-- BƯỚC 3: SỬA VÀ TÁI TẠO STORED PROCEDURE
-- Trong MySQL, để cập nhật thân thủ tục, ta dùng DROP IF EXISTS rồi CREATE lại
-- -----------------------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS `findAllCustomers`//

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers 
    WHERE customerNumber = 175;
END //

DELIMITER ;

-- -----------------------------------------------------------------------------
-- BƯỚC 4: GỌI LẠI PROCEDURE NÂNG CẤP ĐỂ KIỂM TRA KẾT QUẢ
-- -----------------------------------------------------------------------------
CALL findAllCustomers();
