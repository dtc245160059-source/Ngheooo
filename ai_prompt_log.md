# AI Prompt Log - Database Tuning Assistant

## Context 1: Lựa chọn kiểu dữ liệu tài chính
- **User Prompt:** "Khi lưu trữ các khoản tiền như tiền cọc, phí phạt trễ, phí hư hỏng trong MySQL, nên chọn kiểu dữ liệu FLOAT, DOUBLE hay DECIMAL? Tại sao?"
- **AI Response Summary:** Khuyên dùng `DECIMAL(12, 2)` cho dữ liệu tài chính. Kiểu `FLOAT`/`DOUBLE` sử dụng dấu câu động nhị phân gây ra sai số làm tròn (floating-point round-off errors), không đáp ứng tiêu chuẩn kế toán. `DECIMAL` lưu trữ chính xác dưới dạng số cố định.

## Context 2: Thiết kế quan hệ bảng Inspections
- **User Prompt:** "Nên thiết kế bảng Inspections theo quan hệ 1-1 hay 1-N với bảng Rentals? Xét trong bối cảnh thực tế cho thuê xe."
- **AI Response Summary:** Phân tích quan hệ 1-N là tối ưu. Một hợp đồng thuê xe (`Rentals`) trên thực tế có thể có nhiều biên bản kiểm tra (`Inspections`): kiểm tra khi giao xe, kiểm tra sự cố giữa chừng, và kiểm tra khi nhận lại xe. Tách riêng bảng giúp chuẩn hóa dữ liệu 3NF và tránh cột NULL thừa thãi ở bảng chính.

## Context 3: Tránh lỗi tính toán với NULL trong SQL
- **User Prompt:** "Làm thế nào để câu lệnh SELECT tính tiền hoàn cọc `security_deposit - late_fee - damage_fee` không bị trả về NULL nếu một trong các cột phí bị NULL?"
- **AI Response Summary:** Hướng dẫn sử dụng hàm `COALESCE(column_name, 0)` hoặc gán ràng buộc `NOT DEFAULT 0.00` cho các cột phí để đảm bảo phép trừ luôn thực thi chính xác trên số thực.
