# Bước 1:

TLS upload thông tin khách hàng lên portal của TrustConnect. Server lưu lại thông tin khách hàng vào table EC_Transfer_data với status (Remark) = 1.

# Bước 2:

User khởi động bot theo quy trình như sau:

1. Cập nhật chrome lên phiên bản mới nhất bằng [link](chrome://settings/help) (đợi đến khi status hiện Up to date) sau đó tắt hết toàn bộ các tab của chrome.
2. Khởi động session mới của Chrome bằng hướng dẫn khởi động tại [Userguide](UserGuide.md)
3. Khởi động bot theo hướng dẫn tại [Userguide](UserGuide.md) để upload toàn bộ hồ sơ có status = 1
4. Sau khi bot chạy xong, kiểm tra kết quả tại folder chứa file Task.robot

Quy trình hoạt động của bot như sau:

1. Chiếm quyền hoạt động của session chrome đang chạy trên port 9222. Nếu không có session nào sẽ bị lỗi và ngừng chạy.
2. Sau khi điều khiển chrome thành công, điều hướng chrome đến trang đăng ký vay
3. Connect với DB, load toàn bộ hồ sơ đủ điều kiện (có remark = 1)
4. Thực hiện lần lượt từng bước từ 0-4 với thông tin từng hồ sơ. Lưu ý, tại bước 0, nếu số tiền vay hoặc số tháng không nằm trong khoảng phù hợp, bot sẽ lấy giá trị là min (nếu số nhập vào nhỏ hơn khoảng) hoặc max (nếu số nhập vào lớn hơn khoảng)
5. Sau khi hoàn thành bước 4, cập nhật status của hồ sơ (2 nếu bị từ chối hoặc lỗi ở bất kỳ bước nào, 3 nếu gửi thành công)

# Bước 3:

Sau khi kiểm tra kết quả chạy, User thực hiện chỉnh sửa data và khởi động lại bot nếu cần thiết.
