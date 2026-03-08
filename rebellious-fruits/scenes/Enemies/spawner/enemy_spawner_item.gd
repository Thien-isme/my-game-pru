@tool
extends Marker2D

@export_category("Enemy Settings")
## Bấm vào [Open Scene] và chọn loại quái vật bạn muốn đẻ ra ở điểm này.
@export var enemy_scene: PackedScene

## Số lượng quái vật tối đa chui ra từ trụ này trước khi nó ngừng hoạt động.
@export var max_enemies: int = 1
## Thời gian nghỉ (giây) giữa những lần đẻ quái liên tiếp.
@export var spawn_interval: float = 5.0

@export_category("Enemy Stats Overrides")
## Chỉnh lại Sinh lực riêng cho đàn quái ở trụ này. (Để 0.0 để xài máu mặc định của File Gốc)
@export var override_health: float = 0.0
## Ép tốc độ Nhả đạn nhanh hay chậm. Số càng nhỏ nhả đạn càng gắt. (Để 0.0 để xài mặc định)
@export var override_shoot_cooldown: float = 0.0
## Ép tốc độ bay của viên đạn. Quái ở vị trí xa có thể cho đạn bay nhanh hơn. (Để 0.0 để xài mặc định)
@export var override_bullet_speed: float = 0.0

@export_group("Enemy Area Previews (Editor Only)")
## Khoảng cách (Trái-Phải) mà quái sẽ lượn lờ khi chưa phát hiện người chơi. 
## Chú ý: Hình tròn Vàng này chỉ để bạn canh tỉ lệ bằng mắt, không hiện trong Game. (Để 0.0 để xài mặc định)
@export var override_patrol_distance: float = 0.0 :
	set(value):
		override_patrol_distance = value
		queue_redraw()

@export_group("Enemy Area Previews (Editor Only)")
## Bán kính Vùng Đánh Hơi (Detect) - Khi người chơi dẫm vào thì quái sẽ đuổi theo. Mực Xanh Ngọc.
@export var override_detect_radius: float = 0.0 :
	set(value):
		override_detect_radius = value
		queue_redraw()
		
## Bán kính Vùng Tấn Công (Attack) - Khi người chơi dẫm vào thì quái dính đòn / bị xả đạn. Mực Đỏ.
@export var override_attack_radius: float = 0.0 :
	set(value):
		override_attack_radius = value
		queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		# Vẽ lại cái dấu chữ thập cho nét vì ta đã xóa script mặc định của Marker2D
		draw_line(Vector2(-15, 0), Vector2(15, 0), Color.GREEN, 2.0)
		draw_line(Vector2(0, -15), Vector2(0, 15), Color.GREEN, 2.0)
		
		# Draw the preview areas for this specific spawn point
		if override_detect_radius > 0:
			draw_circle(Vector2.ZERO, override_detect_radius, Color(0.1, 0.8, 0.8, 0.2))
		if override_attack_radius > 0:
			draw_circle(Vector2.ZERO, override_attack_radius, Color(0.9, 0.1, 0.3, 0.3))
			
		# Vẽ vòng tròn báo hiệu khoảng cách tuần tra (Patrol Distance)
		if override_patrol_distance > 0:
			draw_circle(Vector2.ZERO, override_patrol_distance, Color(1.0, 0.8, 0.0, 0.25))
