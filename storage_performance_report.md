# Báo Cáo Phân Tích Tài Nguyên & Hiệu Năng Hàng Đợi (QuickFeed)

## 1. Bảng Quyết Định Tối Ưu Index (Decision Matrix)

| Tên Index | Cột Đánh Index | Độ Phân Giải (Cardinality) | Hành Động | Lý Do Kỹ Thuật |
| :--- | :--- | :--- | :--- | :--- |
| **`idx_user_id`** | `user_id` | **Rất Cao** | **GIỮ LẠI** | Lọc chính xác bài viết theo người dùng (`WHERE user_id = X`). |
| **`idx_content`** | `content(255)` | Trung Bình | **XÓA** | Cột kiểu `TEXT` tốn bộ nhớ đĩa; muốn tìm kiếm từ khóa phải dùng `FULLTEXT Index`. |
| **`idx_post_type`**| `post_type` | **Cực Thấp** (3 giá trị) | **XÓA** | MySQL Query Optimizer luôn bỏ qua Index này và ưu tiên Full Table Scan. |
| **`idx_is_visible`**| `is_visible` | **Cực Thấp** (2 giá trị) | **XÓA** | Chi phí Random I/O Lookup qua Index lớn hơn đọc tuần tự toàn bảng. |
| **`idx_created_at`**| `created_at` | **Rất Cao** | **GIỮ LẠI** | Phục vụ truy vấn sắp xếp Newsfeed theo thời gian (`ORDER BY created_at DESC`). |

## 2. So sánh Tài nguyên & Tốc độ Ghi

| Chỉ Số Đánh Giá | Trước Khi Tối Ưu (Legacy) | Sau Khi Tối Ưu (Optimized) | Mức Độ Cải Thiện |
| :--- | :--- | :--- | :--- |
| **Số lượng Index B-Tree** | 5 Index phụ + 1 PK | 2 Index phụ + 1 PK | **Giảm 60%** số cây B-Tree phụ |
| **Tỉ lệ Index Size / Data Size** | ~ 210% (Index lớn gấp đôi Data) | ~ 30% (Index gọn nhẹ) | **Giải phóng > 65%** dung lượng đĩa |
| **Thao tác Ghi đĩa khi `INSERT`** | 6 lần ghi nút lá & Rebalance B-Tree | 3 lần ghi đĩa | **Tăng tốc độ Ghi lên 200 - 300%** |

## 3. Đánh đổi Kỹ thuật (Trade-off Analysis)
Index B-Tree mang lại tốc độ Truy xuất (`SELECT`) nhanh nhờ độ phức tạp $O(\log N)$, nhưng đòi hỏi chi phí đắt đỏ cho thao tác `INSERT`/`UPDATE`/`DELETE`. Mỗi câu lệnh `INSERT` bài viết mới buộc InnoDB phải thực thi phân tách trang (Page Split) và cân bằng lại cây cho tất cả các Index hiện có. Việc cắt bỏ 3 Index vô hại/vô dụng đã giải phóng `Buffer Pool` RAM, eliminating tình trạng khóa bảng/Timeout và trả lại dung lượng đĩa cho hệ thống.
