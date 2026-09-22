# AI Prompt Log - Database Tuning Assistant

## Context 1: Mệnh đề Non-SARGable và B-Tree Index
- **User Prompt:** "Trong MySQL, nếu tôi tạo Index cho một cột ngày tháng, nhưng trong mệnh đề WHERE tôi lại viết WHERE YEAR(col) = 2026, tại sao MySQL lại từ chối sử dụng Index và phải quét toàn bộ bảng (Full Table Scan)?"
- **AI Response Summary:** B-Tree Index sắp xếp dữ liệu theo giá trị nguyên bản của cột. Khi dùng hàm `YEAR(col)`, MySQL không thể biết giá trị đầu ra của hàm nếu chưa thực thi hàm đó trên từng dòng. Do đó, cỗ máy tìm kiếm nhị phân bị phá vỡ, buộc hệ thống quét toàn bảng (`Full Table Scan`).

## Context 2: Thứ tự cột trong Composite Index
- **User Prompt:** "Khi thiết kế một Composite Index cho cột (transaction_type, created_at), thứ tự các cột trong Index có quan trọng không? Tôi nên đặt cột nào đứng trước?"
- **AI Response Summary:** Rất quan trọng. Áp dụng quy tắc "Leftmost Prefix Rule": Đặt cột lọc theo phép so sánh bằng (`=`) là `transaction_type` đứng trước, và cột lọc theo khoảng (`>=`, `<`, `BETWEEN`) là `created_at` đứng sau. Nếu đảo ngược, phép lọc khoảng của `created_at` sẽ chặn không cho MySQL dùng phần Index còn lại của `transaction_type`.

## Context 3: Phân biệt `Using index` và `Using index condition` trong Extra
- **User Prompt:** "Trong kết quả EXPLAIN, cột Extra hiện 'Using index condition' khác gì với 'Using index' (Covering Index)?"
- **AI Response Summary:** 
  - `Using index` (Covering Index): Tất cả các cột trong mệnh đề SELECT đều nằm sẵn trong Index. Engine lấy dữ liệu trực tiếp từ Index mà không cần Lookup về bảng chính (Clustered Index).
  - `Using index condition` (ICP - Index Condition Pushdown): Engine lọc các bản ghi trên B-Tree Index trước, sau đó mới Lookup về bảng chính để lấy các cột còn thiếu (`amount`), giúp giảm bớt số lần I/O đọc ổ đĩa.
