-- ========================================================
-- DỰ ÁN: SMARTFACTORY IOT - DATABASE RE-INDEXING SCRIPT
-- Bảng áp dụng: SensorLogs
-- ========================================================

USE smartfactory_db;

-- 1. Kiểm tra trạng thái và dung lượng ban đầu của bảng SensorLogs
SHOW TABLE STATUS LIKE 'SensorLogs';

-- 2. Xóa bỏ Fat Index dư thừa trên bảng SensorLogs
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- 3. Tạo Lean Index mới tinh gọn phục vụ điều kiện lọc WHERE (sensor_id, recorded_at)
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);

-- 4. Kiểm tra lại dung lượng Index_length sau khi xóa Fat Index
SHOW TABLE STATUS LIKE 'SensorLogs';

-- 5. Lệnh EXPLAIN kiểm chứng hành vi truy vấn trên bảng SensorLogs
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';
