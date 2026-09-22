# AI Prompt Log - SQL Tuning Assistant

## Context 1: Lý thuyết tập hợp của JOIN
- **User Prompt:** "Trong MySQL, mặc định từ khóa JOIN (khi không ghi rõ LEFT hay RIGHT) hoạt động như thế nào? Nó sẽ bỏ qua hay giữ lại các bản ghi không khớp ở hai bảng?"
- **AI Response Summary:** Mặc định `JOIN` hoạt động như `INNER JOIN`. Nó chỉ trả về phần giao (Intersection) giữa hai tập hợp bảng. Mọi bản ghi ở bảng bên trái hoặc bên phải không tìm thấy khóa tương ứng sẽ bị loại bỏ hoàn toàn khỏi kết quả.

## Context 2: Sự khác biệt của hàm COUNT trong LEFT JOIN
- **User Prompt:** "Khi tôi sử dụng LEFT JOIN và đếm số lượng đơn hàng bằng hàm COUNT, tôi nên dùng COUNT(*) hay COUNT(tên_cột_khóa_chính_bảng_order)? Sự khác biệt khi kết quả trả về NULL là gì?"
- **AI Response Summary:** Nên dùng `COUNT(o.order_id)`. `COUNT(*)` đếm tất cả các dòng tồn tại trong tập kết quả sau khi GROUP BY (bao gồm cả dòng mang giá trị NULL do LEFT JOIN tạo ra). `COUNT(column)` sẽ bỏ qua các giá trị NULL, giúp đưa kết quả của các bản ghi mồ côi về 0 đúng thực tế.

## Context 3: Tối ưu hiệu năng Anti-Join vs Subquery
- **User Prompt:** "Hãy phân tích hiệu năng (Performance) của việc dùng LEFT JOIN ... WHERE IS NULL (Anti-Join) so với NOT IN / NOT EXISTS khi muốn tìm kiếm các bản ghi không tồn tại."
- **AI Response Summary:** 
  1. `LEFT JOIN ... WHERE IS NULL`: MySQL Optimizer có thể tận dụng chỉ mục (Index) và thuật toán Block Nested-Loop / Hash Join để quét dữ liệu nhanh chóng.
  2. `NOT IN`: Nếu tập con chứa bất kỳ giá trị `NULL` nào, truy vấn có thể trả về tập rỗng hoặc gây ra quét toàn bảng (Full Table Scan).
  3. `NOT EXISTS` và `Anti-Join` trên các phiên bản MySQL hiện đại (8.0+) có hiệu năng tương đương nhau nhờ bộ tối ưu hóa tự động chuyển đổi cây truy vấn.
