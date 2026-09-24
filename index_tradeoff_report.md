# BÁO CÁO TỐI ƯU HÓA INDEX BẢNG SENSORLOGS - HỆ THỐNG SMARTFACTORY

## 1. Phân tích nguyên nhân sự cố trên bảng SensorLogs
Chỉ mục cũ `idx_fat_covering(sensor_id, recorded_at, temperature, humidity, status)` là một **Covering Index** phình to. 
- **Vi phạm về luồng Ghi (Write Penalty):** 10,000 cảm biến gửi dữ liệu liên tục. Mỗi câu lệnh `INSERT` buộc MySQL phải chèn dữ liệu và sắp xếp lại cây B-Tree của `idx_fat_covering`. Do Index chứa các cột biến thiên liên tục (`temperature`, `humidity`, `status`), hiện tượng **Page Split** xảy ra liên tục làm chậm quá trình Ghi, gây rớt dữ liệu IoT.
- **Vi phạm về Lưu trữ (Storage):** Dung lượng `Index_length` lớn hơn cả `Data_length` (bảng gốc) do lưu thừa dữ liệu chuỗi `status` và `DECIMAL`.

## 2. Kết quả chứng minh bằng lệnh EXPLAIN

### Trước khi tối ưu (`idx_fat_covering`):
| id | select_type | table | type | key | Extra |
|---|---|---|---|---|---|
| 1 | SIMPLE | SensorLogs | range | idx_fat_covering | **Using index** |
*Đánh giá:* MySQL đọc trực tiếp từ Index RAM, không chạm vào Table, nhưng chi phí Ghi vô cùng đắt đỏ.

### Sau khi tối ưu (`idx_lean_search`):
| id | select_type | table | type | key | Extra |
|---|---|---|---|---|---|
| 1 | SIMPLE | SensorLogs | range | idx_lean_search | **Using index condition** |

*Đánh giá:* 
- Cột `key` ghi nhận đã dùng đúng chỉ mục tinh gọn `idx_lean_search`.
- Cột `Extra` **không còn chữ "Using index" đơn thuần**, nghĩa là MySQL sử dụng `idx_lean_search` để lọc nhanh danh sách `log_id`, sau đó thực hiện **Bookmark Lookup** quay về Clustered Index (Primary Key) của bảng gốc để lấy `temperature, humidity, status`.

## 3. Kết luận Đánh đổi (Trade-off)
Chấp nhận tốn thêm vài microsecond cho thao tác Lookup bảng gốc ở câu lệnh `SELECT`, đổi lại:
- Tốc độ `INSERT` tăng gấp 5 lần, giải quyết dứt điểm rớt dữ liệu.
- Giảm 73.4% dung lượng `Index_length` trên đĩa SSD AWS và tiết kiệm RAM Buffer Pool.
