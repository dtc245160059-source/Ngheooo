-- =============================================================================
-- QUICKFEED DATABASE INDEX OPTIMIZATION SCRIPT
-- Role: Database Administrator (DBA)
-- Task: Clean up redundant B-Tree indexes, restore INSERT performance, free disk space
-- =============================================================================

CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

-- -----------------------------------------------------------------------------
-- 1. SETUP BẢNG VÀ CHÈN LẠI CÁC INDEX DƯ THỪA (LEGACY SCRIPT)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS Posts;

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10), -- 'TEXT', 'IMAGE', 'VIDEO'
    is_visible BOOLEAN DEFAULT 1, -- 0 hoặc 1
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Khởi tạo 5 Index gây lỗi nảy sinh từ Legacy Code
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255)); 
CREATE INDEX idx_post_type ON Posts(post_type); 
CREATE INDEX idx_is_visible ON Posts(is_visible); 
CREATE INDEX idx_created_at ON Posts(created_at);

-- -----------------------------------------------------------------------------
-- 2. TRUY VẤN KIỂM TRA DUNG LƯỢNG DATA VÀ INDEX TRƯỚC KHI TỐI ƯU
-- Sử dụng information_schema.TABLES để tính toán dung lượng theo đơn vị MB
-- -----------------------------------------------------------------------------
SELECT 
    table_name AS `Table`,
    ROUND(((data_length) / 1024 / 1024), 2) AS `Data_Size_MB`,
    ROUND(((index_length) / 1024 / 1024), 2) AS `Index_Size_MB`,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- -----------------------------------------------------------------------------
-- 3. CẮT BỎ (DROP) CÁC INDEX DƯ THỪA / LOW CARDINALITY
-- -----------------------------------------------------------------------------
-- Xóa idx_content: Do cột TEXT kích thước quá lớn, làm phình Index Pages
ALTER TABLE Posts DROP INDEX idx_content;

-- Xóa idx_post_type: Do Cardinality cực thấp (chỉ có 3 giá trị)
ALTER TABLE Posts DROP INDEX idx_post_type;

-- Xóa idx_is_visible: Do Cardinality cực thấp (chỉ có 2 giá trị: 0 và 1)
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- -----------------------------------------------------------------------------
-- 4. TRUY VẤN ĐỐI CHIẾU DUNG LƯỢNG SAU KHI DỌN DẸP INDEX
-- -----------------------------------------------------------------------------
SELECT 
    table_name AS `Table`,
    ROUND(((data_length) / 1024 / 1024), 2) AS `Data_Size_MB`,
    ROUND(((index_length) / 1024 / 1024), 2) AS `Index_Size_MB`,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';
