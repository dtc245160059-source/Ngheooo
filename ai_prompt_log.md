# AI Prompt Log - Storage & Performance Profiler

## Context 1: Tác hại của Index trên cột TEXT và BOOLEAN
- **User Prompt:** "Trong MySQL, nếu tôi tạo Index trên một cột chứa văn bản dài (TEXT) và một cột kiểu BOOLEAN (0 và 1), thì điều này gây hại như thế nào đến bộ nhớ RAM, dung lượng Disk và bộ tối ưu hóa (Query Optimizer)?"
- **AI Response Summary:** 
  - *Cột TEXT:* Tạo IndexPrefix chiếm dung lượng lớn trên đĩa và RAM (Buffer Pool), làm giảm số lượng trang dữ liệu thô có thể cache.
  - *Cột BOOLEAN:* Cardinality = 2 (tỉ lệ phân biệt quá thấp). Query Optimizer nhận thấy chi phí dùng Index để Bookmark Lookup từng dòng đắt hơn việc đọc tuần tự (Sequential Read) toàn bảng, nên Index này hoàn toàn không được sử dụng nhưng vẫn tốn chi phí cập nhật khi `INSERT`.

## Context 2: Lý do MySQL từ chối Index có Cardinality thấp
- **User Prompt:** "Tại sao khi tôi truy vấn `SELECT * FROM Posts WHERE is_visible = 1` trên một bảng có hàng triệu dòng (trong đó 99% bài viết là visible = 1), MySQL lại quyết định quét toàn bảng (Full Table Scan) thay vì sử dụng Index idx_is_visible đã tạo?"
- **AI Response Summary:** Khi tỉ lệ dữ liệu thỏa mãn điều kiện vượt quá 20%-30% tổng số dòng, chi phí nhảy qua lại giữa B-Tree Index và Clustered Index (Random I/O) cao hơn nhiều so với việc càn qua toàn bộ các trang dữ liệu trên đĩa (Sequential Read). Vì vậy, Optimizer bỏ qua B-Tree Index và chọn Full Table Scan.

## Context 3: Giải pháp tìm kiếm từ khóa không tốn tài nguyên B-Tree
- **User Prompt:** "Nếu muốn tìm kiếm từ khóa bên trong cột content (kiểu TEXT) mà không bị tốn quá nhiều dung lượng như B-Tree Index, tôi nên sử dụng cơ chế nào của MySQL?"
- **AI Response Summary:** Nên chuyển sang sử dụng `FULLTEXT Index` (dựa trên cấu trúc Inverted Index). Nút tìm kiếm lưu trữ danh sách các từ (Token) kèm vị trí thay vì lưu trữ chuỗi văn bản dài, giúp tối ưu hóa dung lượng đĩa và hỗ trợ tìm kiếm ngữ nghĩa (`MATCH...AGAINST`).
