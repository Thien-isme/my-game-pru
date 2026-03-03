# TÀI LIỆU THIẾT KẾ GAME: SHIPPER SÁT NÁCH (2D TOP-DOWN)

## 1. THÔNG TIN CHUNG
* **Tên dự án:** Shipper Sát Nách (The Barking Delivery)
* **Thể loại:** Hành động rượt đuổi, Hài hước (2D Top-down Action)
* **Công cụ:** Godot Engine 4.x
* **Phong cách đồ họa:** 2D Top-down (Góc nhìn từ trên xuống trực diện)
* **Nhân vật chính:** Minh - Một shipper chạy xe đạp cà tàng.

## 2. CỐT TRUYỆN (CONCEPT)
Minh là một shipper mới vào nghề tại "Quận Gâu Gâu". Để hoàn thành các đơn hàng trong thời gian vàng và lấy tiền bonus, Minh phải đi tắt qua những con hẻm nhỏ - nơi lũ chó luôn coi xe đạp là "kẻ thù không đội trời chung". Bạn phải giúp Minh giao hàng thành công mà không để lũ chó xé rách gói hàng (hoặc rách quần).

## 3. CƠ CHẾ ĐIỀU KHIỂN & PHƯƠNG TIỆN (XE ĐẠP)
### A. Điều khiển:
* **Di chuyển:** WASD hoặc Phím mũi tên (8 hướng).
* **Tăng tốc (Sprint):** Giữ phím `Shift`. Tiêu tốn thanh thể lực (Stamina). Khi hết thể lực, xe đạp sẽ đi rất chậm trong 3 giây để hồi sức.
* **Chuông xe:** Phím `Space`. Tạo sóng âm vòng tròn làm chó trong vùng ảnh hưởng bị "choáng" (Stun) trong 1 giây.

### B. Đặc điểm xe đạp 2D:
* **Quán tính (Inertia):** Xe không dừng lại ngay khi thả phím, tạo độ trượt nhẹ khiến việc lách qua hẻm hẹp khó khăn hơn.
* **Va chạm:** Nếu đâm vào tường hoặc vật cản, Minh sẽ mất 1 giây để lấy lại thăng bằng.

## 4. HỆ THỐNG KẺ ĐỊCH (LŨ CHÓ)
Mỗi loại chó có cách tấn công khác nhau:
* **Chó Cỏ (Basic):** Đuổi theo khi thấy người, tốc độ trung bình, dễ bị cắt đuôi.
* **Chó Poodle (The Shouter):** Không cắn mạnh nhưng sủa rất to, làm thanh "Hoảng loạn" của Minh tăng nhanh, gây rung màn hình.
* **Chó Pitbull (The Tanker):** Chạy rất nhanh, nếu húc trúng sẽ làm Minh ngã xe ngay lập tức.
* **Chó Boss (Ngao Tây Tạng):** Xuất hiện ở màn cuối, có thể cắn vào đuôi xe và lôi ngược Minh lại.

## 5. CƠ CHẾ "CẮT ĐUÔI" & THOÁT HIỂM
* **Khoảng cách:** Thoát khỏi vùng lãnh thổ (Leashing zone) của con chó.
* **Mất dấu (Line of Sight):** Chạy ra sau các bức tường hoặc góc khuất của ngôi nhà.
* **Mồi nhử:** Nhấn phím `E` để ném xương/xúc xích đánh lạc hướng chó trong 3-5 giây.
* **Địa hình:** Đi vào vùng nước (chó sợ ướt) hoặc chạy qua cửa tự động đóng.

## 6. CẤU TRÚC MÀN CHƠI (20 MÀN)
* **Chương 1: Ngõ Nhỏ Việt Nam (Màn 1-5):** Đường phố đơn giản, ít chó dữ. Mục tiêu là làm quen cách điều khiển xe đạp 2D.
* **Chương 2: Mê Cung Chung Cư (Màn 6-12):** Ngõ cụt nhiều, góc cua 90 độ liên tục. Đơn hàng là đồ dễ vỡ (Pizza/Trứng).
* **Chương 3: Khu Đô Thị Cao Cấp (Màn 13-20):** Sân vườn rộng lớn nhưng đầy rẫy chó săn. Cần phối hợp ném mồi và dùng kỹ năng chuông xe để win.

## 7. ĐIỀU KIỆN THẮNG/THUA
* **Thắng:** Đưa gói hàng đến vùng "Goal" (vòng tròn xanh trước cửa nhà khách).
* **Thua:** Độ bền gói hàng về 0 hoặc Minh bị ngã xe quá 3 lần trong một màn chơi.

## 8. HƯỚNG DẪN KỸ THUẬT CHO AI HỖ TRỢ
* **Lập trình:** Sử dụng `CharacterBody2D` cho người và chó. Dùng `NavigationAgent2D` để xử lý AI tìm đường.
* **Đồ họa:** Yêu cầu AI tạo "Top-down 2D Sprite Sheets" cho nhân vật đạp xe và chó chạy 4 hướng.
* **TileMap:** Sử dụng hệ thống TileSet 2D để vẽ bản đồ thành phố dạng lưới.