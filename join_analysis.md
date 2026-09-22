# Giải Trình Sử Dụng `COUNT(o.order_id)` Thay Vì `COUNT(*)`

Khi thực hiện `LEFT JOIN`, các bản ghi ở bảng chính (`Customers`) không có giao dịch tương ứng ở bảng phụ (`Orders`) vẫn được giữ lại, nhưng tất cả các cột thuộc bảng `Orders` sẽ nhận giá trị `NULL` (ví dụ: khách hàng Charlie).

- **`COUNT(*)`**: Đếm tổng số lượng dòng trong mỗi nhóm mà không quan tâm giá trị các cột có `NULL` hay không. Khách hàng chưa mua hàng có 1 dòng chứa giá trị `NULL`, do đó `COUNT(*)` đếm dòng này và trả về **1** đơn hàng (kết quả sai lệch).
- **`COUNT(o.order_id)`**: Chỉ đếm các giá trị **khác NULL** trên cột chỉ định. Khi khách hàng chưa mua hàng, `o.order_id` là `NULL`, hàm `COUNT` sẽ bỏ qua và trả về chính xác **0** đơn hàng.

Sử dụng `COUNT(o.order_id)` là điều kiện bắt buộc để đảm bảo tính chính xác cho các phép đếm trên bảng tham chiếu trong `LEFT JOIN`.
