# Báo Cáo Phân Tích Hiệu Năng EXPLAIN (PayFlow System)

## So sánh Chỉ số Thực thi trước và sau Tối ưu hoá

| Chỉ số trong EXPLAIN | Trước khi Tối ưu (Legacy Query) | Sau khi Tối ưu (Optimized Query) |
| :--- | :--- | :--- |
| **`select_type`** | `SIMPLE` | `SIMPLE` |
| **`type`** | **`ALL`** (Full Table Scan) | **`range`** (Index Range Scan) |
| **`possible_keys`** | `NULL` | `idx_type_date` |
| **`key`** | `NULL` | `idx_type_date` |
| **`rows`** | ~5,000,000 dòng (quét toàn bộ) | ~150,000 dòng (chỉ quét T6/2026) |
| **`Extra`** | `Using where` | `Using index condition` |

## Nhận xét chi tiết
1. **Nguyên nhân sự cố**: Truy vấn cũ bọc hàm `YEAR()` và `MONTH()` vào cột `created_at` (Non-SARGable), làm vô hiệu hóa B-Tree Index và buộc MySQL phải dùng `type = ALL` để tính toán từng dòng trên 5 triệu bản ghi.
2. **Hiệu quả cải tiến**: Chuyển điều kiện sang phép so sánh khoảng `created_at >= '2026-06-01' AND created_at < '2026-07-01'` giúp truy vấn trở thành SARGable. MySQL kích hoạt `Composite Index (transaction_type, created_at)` nhảy trực tiếp đến nút lá chứa dữ liệu Tháng 6, giảm **97%** lượng dòng phải quét và giải phóng CPU máy chủ.
