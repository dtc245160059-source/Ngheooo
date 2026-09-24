# Báo Cáo Phân Tích & Tái Cấu Trúc Layout CreativeChronicle

### Tác hại của `position: absolute` đối với Responsive Design
Thuộc tính `position: absolute` tách phần tử hoàn toàn ra khỏi luồng tài liệu chuẩn (Document Flow). Do phần tử cha không thể tự đo đạc chiều rộng/chiều cao của các phần tử con này, người lập trình buộc phải ép chiều cao cứng (`height: 400px`). Khi hiển thị trên màn hình nhỏ, nội dung bên trong bị gập lại hoặc tràn ra ngoài nhưng khung chứa không thể tự mở rộng, dẫn đến việc phần tử bên dưới (đoạn văn bài viết) đè lên hình ảnh.

### CSS Grid & Flexbox - Giải pháp cứu cánh
- **CSS Grid (2D):** Định hình khung Mosaic Gallery tự nhiên theo hàng và cột. Việc thay đổi layout trên Mobile chỉ tốn 3 dòng code CSS trong Media Query mà không làm đứt gãy luồng văn bản.
- **Flexbox (1D):** Xử lý hoàn hảo việc căn giữa chiều dọc (`align-items: center`) cho thanh thông tin tác giả mà không cần dùng clearfix hay float.
