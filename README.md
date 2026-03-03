# GAME DESIGN DOCUMENT: SHIPPER SÁT NÁCH (THE BARKING DELIVERY)

## 1. TỔNG QUAN DỰ ÁN
* **Tên Game:** Shipper Sát Nách (The Barking Delivery)
* **Thể loại:** Hành động, Hài hước, Rượt đuổi (Arcade/Action)
* **Công cụ phát triển:** Godot Engine
* **Định dạng đồ họa:** 2.5D (Nhân vật 2D Sprites trong môi trường 3D)
* **Góc nhìn:** Isometric (Nghiêng 3/4 từ trên xuống)
* **Phương tiện chính:** Xe đạp

## 2. CỐT TRUYỆN
Người chơi vào vai Minh - một nhân viên giao hàng mới vào nghề tại "Quận Gâu Gâu". Để hoàn thành chỉ tiêu giao hàng nhanh, Minh phải đạp xe xuyên qua các con ngõ đầy chó dữ. Nhiệm vụ của bạn là giao hàng đúng đích, bảo vệ kiện hàng và sống sót trước những cú táp của lũ chó trong xóm.

## 3. CẤU TRÚC MÀN CHƠI (CAMPAIGN)
Chia làm 3 Chương với tổng cộng 20 màn chơi:
* **Chương 1: Ngõ Nhỏ Thân Thiện (5 màn):** Đường thẳng, chó nhỏ (Poodle, Chó cỏ), độ khó thấp để làm quen nút.
* **Chương 2: Chung Cư Hỗn Loạn (7 màn):** Nhiều ngõ cụt, góc cua gắt. Chó dữ (Becgie, Pitbull). Hàng hóa là đồ dễ vỡ (Pizza, trà sữa).
* **Chương 3: Biệt Thự Đại Gia (8 màn):** Mê cung vườn tược. Chó Boss (Ngao Tây Tạng). Hệ thống cửa tự động và bẫy môi trường.

## 4. CƠ CHẾ ĐIỀU KHIỂN & GAMEPLAY
### A. Nhân vật & Xe đạp:
* **Di chuyển:** Phím điều hướng (WASD/Arrows).
* **Tăng tốc (Sprint):** Nhấn giữ phím Shift (Tiêu tốn thanh Stamina).
* **Chuông xe (Kỹ năng):** Phím Space. Làm chó giật mình/choáng (Stun) trong 0.5s.
* **Ném vật phẩm (Decoy):** Phím E. Ném xương hoặc xúc xích để đánh lạc hướng chó.

### B. Cơ chế Tương tác (Chó vs Người):
* **Tầm nhìn (Line of Sight):** Chó chỉ đuổi khi người chơi đi vào vùng phát hiện.
* **Tác động:** * Chó cắn chân: Làm chậm tốc độ xe.
    * Chó húc: Gây ngã xe, người chơi phải nhấn phím liên tục để đứng dậy.
    * Chó táp hàng: Làm giảm độ bền kiện hàng.
* **Cắt đuôi (Reset Aggro):** Chạy thoát khỏi bán kính lãnh thổ của chó hoặc nấp sau vật cản để chó mất dấu.

## 5. ĐIỀU KIỆN CHIẾN THẮNG
* **Win:** Giao hàng đến đúng vị trí mục tiêu (Area3D) với độ bền hàng hóa > 0%.
* **Lose:** Độ bền hàng hóa về 0% hoặc nhân vật bị chó tấn công quá nhiều lần khiến thanh máu cạn kiệt.
* **Hệ thống đánh giá:** 1-3 sao dựa trên Thời gian hoàn thành và Độ nguyên vẹn của hàng.

## 6. YÊU CẦU KỸ THUẬT CHO AI HỖ TRỢ (PROMPTS GUIDELINES)
* **Đối với AI Tạo Ảnh (Leonardo/Midjourney):** Tạo bộ "2.5D Isometric Tileset" bao gồm: mặt đường nhựa, hàng rào gỗ, thùng rác, và các bụi cây. Nhân vật là "Delivery man on a bicycle" ở 8 hướng khác nhau.
* **Đối với AI Lập Trình (Coding):** Sử dụng `CharacterBody3D` cho xe đạp và `NavigationAgent3D` cho AI của chó. Sử dụng hệ thống `State Machine` để quản lý trạng thái của chó (Idle, Chase, Return).