# 🍈 Rebellious Fruits (Sự Nổi Loạn Của Trái Cây)

## 📖 Giới thiệu (Overview)
Rebellious Fruits là một tựa game hành động 2.5D mang phong cách Run & Gun kết hợp với Bullet Hell (mưa bom bão đạn). Trò chơi đòi hỏi người chơi phải có phản xạ nhanh tay lẹ mắt, vừa xả đạn tiêu diệt kẻ thù, vừa luồn lách né tránh các luồng đạn từ nhiều hướng khác nhau.  

Đồ họa game mang phong cách cartoon rực rỡ, lấy chủ đề Robo Trái Cây đầy hài hước nhưng gameplay lại cực kỳ thử thách và mãn nhãn.

## 🎯 Cơ chế cốt lõi (Core Mechanics)
- Góc nhìn 2.5D Side-scrolling (Nhân vật và gameplay 2D, background có chiều sâu Parallax).
- Điều khiển: Di chuyển qua lại, Nhảy (Jump), Cúi người (Crouch) và Bắn (Shoot).
- Lối chơi Bullet Hell: Kẻ thù xuất hiện từ nhiều góc và xả đạn liên tục. Người chơi phải kết hợp các nút di chuyển để tìm góc mù hoặc né đạn.
- Điều kiện thắng (Win Condition):  
  1. Phải tiêu diệt ít nhất 80% tổng số kẻ thù trong màn.  
  2. Sống sót đi đến điểm đích cuối cùng.  

(Lưu ý: Không thể speedrun chạy thẳng qua màn mà phải đứng lại giao tranh).

## 🤖 Nhân vật (Player)
**Robo Sầu Riêng**  
Một chiến binh sầu riêng mặc giáp robot cơ khí. Sử dụng súng năng lượng bắn ra các quả sầu riêng nhỏ. Lớp vỏ gai sần sùi đóng vai trò như áo giáp vững chắc.

---

## 🍎 Kẻ thù – Quân Đoàn Trái Cây (The Fruit Legion)

Mỗi loại trái cây có một kiểu tấn công riêng biệt, tạo ra lưới đạn phức tạp, buộc người chơi phải thay đổi lối chơi liên tục.

### 1. Táo Đột Kích (Apple)
- **Vai trò**: Lính cơ bản.
- **Hành vi**: Chạy nhanh về phía người chơi.
- **Tấn công**: Bắn những loạt đạn hạt táo thẳng về phía trước. Dễ tiêu diệt nhưng xuất hiện đông, tạo áp lực phủ màn hình.

### 2. Cam Nổ Chậm (Orange)
- **Vai trò**: Bom hẹn giờ lăn trên mặt đất.
- **Hành vi**: Lăn tròn như quả bóng bowling.
- **Tấn công**: Nếu không bị tiêu diệt kịp thời, sẽ nổ tung và bắn tia nước ép văng ra 8 hướng (pattern hình sao).

### 3. Dưa Hấu Súng Máy (Watermelon)
- **Vai trò**: Lính hạng nặng.
- **Hành vi**: Đứng im hoặc di chuyển chậm.
- **Tấn công**: Há miệng xả một tràng hạt dưa hấu liên tục, tạo bức tường đạn chặn đường tiến của người chơi.

### 4. Lựu Lựu Đạn (Pomegranate)
- **Vai trò**: Tạo spread-shot.
- **Hành vi**: Lùi lại rồi bật lên tấn công.
- **Tấn công**: Phóng ra chùm hạt lựu đỏ theo hình quạt (Spread shot), buộc người chơi tìm khe hở để lách qua.

### 5. Thanh Long Phun Lửa (Dragon Fruit)
- **Vai trò**: Kẻ thù tầm trung, zoner.
- **Hành vi**: Thường trụ trên cao hoặc ở nền sau.
- **Tấn công**: Sử dụng vảy để phóng ra một tia laser/lửa nước ép quét từ trên xuống dưới, cắt ngang màn hình.

### 6. Phi Tiêu Khế (Starfruit)
- **Vai trò**: Không quân.
- **Hành vi**: Bay lượn trên cao theo đường sin.
- **Tấn công**: Phi những tia đạn sắc lẹm xuống đầu người chơi, tạo các đường bắn chéo khó đoán.

### 7. Dưa Leo Bắn Tỉa (Cucumber)
- **Vai trò**: Sniper.
- **Hành vi**: Đứng ở góc xa hoặc trên bệ cao.
- **Tấn công**: Chiếu tia laser đỏ cảnh báo rồi bắn một viên đạn cực nhanh theo đường thẳng. Người chơi phải cúi hoặc nhảy né đúng thời điểm.

### 8. Măng Cụt Bọc Thép (Mangosteen)
- **Vai trò**: Tanker bán bất tử.
- **Hành vi**: Thường khép vỏ tím rất cứng.
- **Tấn công**: Chỉ mở vỏ ra trong khoảnh khắc để bắn những quả cầu ánh sáng có khả năng homing theo người chơi một đoạn ngắn — đó cũng là lúc duy nhất để gây sát thương lên nó.

### 9. Ruồi Nhãn (Longan)
- **Vai trò**: Đàn quấy rối (swarm).
- **Hành vi**: Xuất hiện theo bầy đàn, bay lộn xộn gây rối mắt.
- **Tấn công**: Thỉnh thoảng lao sầm vào người chơi theo kiểu Kamikaze, gây sát thương cận chiến.

### 10. Thanh Long Ninja (Dragon Fruit Ninja)
- **Ngoại hình**:  
  Thân hình thon dài màu đỏ tươi, các vảy hồng nhọn mọc tua tủa như gai kiếm. Đeo mặt nạ ninja đen che nửa mặt, mắt phát sáng xanh lạnh. Hai tay cầm hai lưỡi phi tiêu làm từ vảy của chính nó.
- **Cơ chế tấn công**:  
  Dịch chuyển tức thời (blink) từ điểm này sang điểm khác, để lại vệt đạn vảy nhọn theo đường di chuyển. Người chơi không thể đoán trước hướng xuất hiện tiếp theo, buộc phải quan sát toàn màn hình.

### 11. Chôm Chôm Cuồng Chiến (Rambutan Berserker)
- **Ngoại hình**:  
  Một khối cầu tròn đỏ rực phủ đầy râu lông cứng như dây thép gai, mắt đỏ hừng hực điên loạn. Cơ thể rung lắc liên tục như đang nổi cơn thịnh nộ. Kích thước vừa, đi bằng hai chân ngắn cụt.
- **Cơ chế tấn công**:  
  Lao thẳng vào người chơi theo đường thẳng với tốc độ cao. Khi bị bắn trúng mà chưa chết, nó nổi điên — tốc độ tăng gấp đôi và phóng ra một vòng tròn râu nhọn 360° trước khi lao tiếp.

### 12. Vải Thiều Phù Thủy (Lychee Witch)
- **Ngoại hình**:  
  Vỏ ngoài màu hồng đỏ sần sùi, thân trên mặc áo choàng đen có họa tiết hạt vải. Cầm cây gậy phép làm từ cành nhãn khô, đỉnh gậy gắn một hạt vải đen phát ánh sáng tím huyền bí. Mắt nhắm hờ, toát vẻ yêu ma.
- **Cơ chế tấn công**:  
  Triệu hồi các hạt vải bay lơ lửng xung quanh người chơi như vòng vây. Sau 3 giây, các hạt đồng loạt lao vào — người chơi phải tìm và bắn phá trước khi chúng khép vòng. Nếu bị bao vây hoàn toàn, sát thương cực lớn.

### 13. Chanh Điện Giật (Electric Lemon)
- **Ngoại hình**:  
  Thân hình oval vàng chói, có các tia sét nhỏ liên tục phóng ra từ hai đầu nhọn. Mặc áo gi-lê kỹ thuật viên màu vàng chanh với các ký hiệu điện. Mắt hình tia sét, miệng nhe răng nhọn cười thách thức.
- **Cơ chế tấn công**:  
  Phóng luồng điện theo đường thẳng ngang — đạn xuyên tường, đi qua cả chướng ngại vật. Sau mỗi lần bắn, nó nạp điện trong 2 giây (không tấn công được) — đây là cửa sổ thời gian duy nhất để phản công.

### 14. Bắp Pháo Binh (Corn Artillery)
- **Ngoại hình**:  
  To lớn, bệ vệ, thân hình trụ vàng ươm bọc trong lớp giáp lá xanh như áo giáp lính. Đầu đội mũ bảo hiểm hình cùi bắp. Hai tay là hai khẩu pháo làm từ lõi bắp rỗng.
- **Cơ chế tấn công**:  
  Đứng yên một chỗ và bắn đạn cong theo đường parabol — đạn bay lên cao rồi rơi xuống vị trí người chơi đứng. Người chơi phải liên tục di chuyển. Khi bị tiêu diệt, nó phát nổ bắn hạt bắp văng ra 12 hướng.

### 15. Cà Chua Gián Điệp (Tomato Spy)
- **Ngoại hình**:  
  Tròn trịa màu đỏ với núm cuống đội như chiếc mũ bê-rê đen của điệp viên. Mặc vest đen thanh lịch, đeo kính râm, tay cầm máy ảnh miniature. Trông vô hại và thậm chí đáng yêu — đó chính là bẫy.
- **Cơ chế tấn công**:  
  Không tấn công trực tiếp. Nó chạy trốn và chụp ảnh người chơi. Mỗi tấm ảnh chụp được sẽ triệu hồi thêm 2 kẻ thù khác vào màn hình. Nếu không bị tiêu diệt đủ nhanh, nó liên tục nhân đôi số lượng quân địch, biến màn hình thành địa ngục đạn.

---

## 🧪 Gợi ý mở rộng (Enemy Ideas – Rau Củ & Trái Cây Ít Làm Sinh Tố)

Nhóm kẻ thù lấy cảm hứng từ các loại hoa quả, rau củ ít khi được dùng làm sinh tố đá, tạo cảm giác "dị", bất thường:

- **Mướp Đắng Bom Đắng (Bitter Gourd Bomber)** – ném bom đắng tạo vùng độc.
- **Cà Tím Pháp Sư (Eggplant Enchanter)** – dùng phép bắn cà con homing.
- **Củ Cải Lao Tốc (Daikon Dasher)** – lao thẳng như tên lửa, nổ rải đạn.
- **Khoai Lang Bắn Tỉa (Sweet Potato Sniper)** – núp xa bắn laser cam.
- **Bí Đỏ Nghiền Nát (Pumpkin Pulverizer)** – tank đập đất, summon hạt bí.
- **Bắp Cải Mây Mù (Cauliflower Cloudmaker)** – phun mây trắng che tầm nhìn.
- **Cải Xoăn Cảm Tử (Kale Kamikaze)** – lao kamikaze, nổ lá xoáy.
- **Su Su Tăng Tốc (Chayote Charger)** – blink ngắn, bắn gai parabol.
- **Ổi Sương Độc (Guava Gasser)** – phun sương làm chậm + summon ổi con.
- **Dừa Nghiền (Coconut Crusher)** – rơi từ trên xuống, vỡ bắn nước AoE.
- **Mít Bẫy Dính (Jackfruit Jammer)** – nhựa dính giữ chân, nổ nhựa cuối.
- **Cherry Song Sinh (Cherry Cloner)** – bị bắn thì nhân bản, max 4.
- **Vải Bầy Đàn (Lychee Swarm)** – đàn 5 con lao xoáy, leader bắn laser.
- **Thanh Long Trắng (White Dragonfruit)** – blink + phun laser quạt 90°.

(Các nhân vật mở rộng này có thể tách sang file `ENEMIES_EXTENDED.md` nếu cần.)

---

## 🏭 Màn chơi (Level Design)

### Level 1 – Nhà Máy Sinh Tố Hủy Diệt (The Blender Factory)

- **Bối cảnh**:  
  Một nhà máy công nghiệp u ám với các cỗ máy xay khổng lồ và các bồn chứa nước ép phát sáng neon.

- **Tương phản đồ họa**:  
  Máy móc xám xịt kết hợp với màu sắc rực rỡ của đạn trái cây, giúp người chơi dễ nhận diện chướng ngại vật và bullet pattern.

- **Nhịp độ**:  
  Cấu trúc màn hình hình sin, xen kẽ giữa những đoạn hành động nghẹt thở và các khoảng dừng ngắn. Kết thúc bằng một pha tử thủ xả súng trước cửa đích.

---

Phát triển bởi **Thiện**
