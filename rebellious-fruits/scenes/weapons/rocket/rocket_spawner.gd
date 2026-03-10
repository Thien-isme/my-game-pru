extends Node2D

@export var rocket_scene: PackedScene = preload("res://scenes/weapons/rocket/rocket.tscn")
@export var spawn_interval: float = 5.0
@export var spawn_radius: float = 800.0  # Bán kính vùng tròn xuất hiện quanh Player

@onready var timer: Timer = $Timer

func _ready() -> void:
	if timer:
		timer.wait_time = spawn_interval
		timer.start()
		if not timer.timeout.is_connected(_on_timer_timeout):
			timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	_spawn_rocket_at_player()

func _spawn_rocket_at_player() -> void:
	if not rocket_scene:
		push_error("Rocket Spawner is missing rocket_scene!")
		return
		
	# Tìm player trong tree
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var target_player = players[0]
		
		# Khởi tạo rocket
		var rocket = rocket_scene.instantiate()
		get_tree().current_scene.add_child(rocket)
		
		# 1. Random vị trí Spawn TRONG NỬA VÒNG TRÒN PHÍA TRÊN Player
		var target_pos = target_player.global_position
		
		# Tạo một góc ngẫu nhiên (từ -PI đến 0) => Nửa vòng tròn phía trên đầu
		var rand_angle = randf_range(-PI, 0)
		# Lấy bán kính cố định 800px để tên lửa luôn nằm trên cao
		var spawn_offset = Vector2(cos(rand_angle), sin(rand_angle)) * spawn_radius
		
		rocket.global_position = target_pos + spawn_offset
		
		# Vector chỉ từ Rocket tới Player
		var dir_to_player = (target_pos - rocket.global_position).normalized()
		
		# Gán hướng bay cho viên đạn (Script của Rocket sẽ tự lo việc xoay hình)
		if "direction" in rocket:
			rocket.direction = dir_to_player
		
		# Lưu ý: Do Sprite gốc của Rocket có hình bay ngang hay dọc? 
		# Nếu Sprite tên lửa gốc đang bay NGANG ngòi sang PHẢI (như viên đạn) thì để nguyên.
		# Hiện tại trong SpriteFrames, nó bay NGANG chéo chéo, có thể cần cộng thêm một offset (VD: + PI/2)
		# Tạm thời cứ để angle() thuần túy, có thể quan sát và bổ sung offset sau.
		
		# Trong bản cập nhật mới nhất, ta đã chỉnh rocket.tscn AnimatedSprite2D rotation = 1.68 (~96 độ)
		# Nghĩa là sprite gốc chĩa lên trên hoặc chéo. Việc gán lại `rocket.rotation` sẽ xoay toàn bộ cụm Area2D.
