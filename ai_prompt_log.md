# Nhật Ký Tương Tác AI (Prompt Log)

### Prompt 1: Tìm hiểu CSS Grid cho Mosaic Layout
- **Nội dung:** "Tôi có 3 hình ảnh. Tôi muốn tạo layout Mosaic bằng CSS Grid với 1 hình lớn chiếm full 2 hàng bên trái (width 2fr) và 2 hình nhỏ xếp chồng bên phải (width 1fr). Cú pháp CSS nào tối ưu nhất?"
- **Kết quả:** Áp dụng `grid-template-columns: 2fr 1fr;` kết hợp `grid-row: span 2;` cho ảnh chính và `object-fit: cover`.

### Prompt 2: Tra cứu Utility Classes của Bootstrap 5
- **Nội dung:** "Trong Bootstrap 5, có những class d-flex nào giúp căn giữa phần tử theo chiều dọc và tạo khoảng cách giữa các phần tử con mà không cần viết CSS thuần?"
- **Kết quả:** Sử dụng `d-flex align-items-center justify-content-between gap-3`.

### Prompt 3: Cấu hình Breakpoints cho Card Grid
- **Nội dung:** "Cấu trúc HTML Bootstrap Grid nào cho phép hiển thị 4 cột trên Desktop (>=992px), 2 cột trên Tablet (>=768px) và 1 cột trên Mobile?"
- **Kết quả:** Sử dụng `col-12 col-md-6 col-lg-3` bên trong `<div class="row g-4">`.
