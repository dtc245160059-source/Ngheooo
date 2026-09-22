# Phân Tích Sự Cần Thiết Của Cột `damage_fee` Trong CSDL AutoRide

Trong quy trình kinh doanh (UML Activity Diagram) của AutoRide, nhánh rẽ trả xe phát sinh hai rủi ro tài chính: trả xe trễ giờ và xe bị tổn hại. Cột `damage_fee` trong bảng `Rentals` đóng vai trò là điểm chốt dữ liệu bắt buộc vì những lý do sau:

1. **Đảm bảo tính toàn vẹn tài chính:** Khi kiểm tra xe phát hiện lỗi (`Inspections`), chi phí sửa chữa phải được định lượng bằng số tiền cụ thể để trừ trực tiếp vào `security_deposit`. Nếu thiếu `damage_fee`, kế toán không có cơ sở dữ liệu hợp lệ để xuất hóa đơn hoàn tiền, dẫn đến việc phải hoàn full tiền cọc hoặc thu tiền mặt thủ công bên ngoài hệ thống.
2. **Khớp nối quy trình nghiệp vụ với dữ liệu:** Cột `damage_fee` chuyển hóa kết quả đánh giá định tính từ bảng `Inspections` (mô tả lỗi bằng văn bản) thành giá trị định lượng để phục vụ công thức: 
   `Tiền hoàn lại = Tiền cọc - Phí trễ - Phí hư hỏng`.
3. **Ngăn chặn thất thoát lợi nhuận:** Thiếu thuộc tính này khiến hệ thống "bỏ quên" các khoản đền bù, là nguyên nhân trực tiếp khiến AutoRide chịu toàn bộ chi phí sửa chữa và lỗ nặng vận hành.
