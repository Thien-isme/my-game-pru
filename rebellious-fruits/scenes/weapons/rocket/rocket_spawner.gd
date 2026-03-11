extends Node2D

@export var rocket_scene: PackedScene = preload("res://scenes/weapons/rocket/rocket.tscn")
@export var spawn_interval: float = 5.0
@export var spawn_width: float = 1600.0 # Chiều rộng của đường thẳng (line) thả tên lửa
@export var spawn_height_offset: float = 800.0 # Khoảng cách từ đỉnh đầu Player lên tới đường thả bom

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
		
		# 1. Random vị trí Spawn TRÊN MỘT ĐƯỜNG THẲNG PHÍA TRÊN Player
		var target_pos = target_player.global_position
		
		# Random một điểm X nằm trong khoảng spawn_width/2 về hai phía trái phải
		var random_x = randf_range(-spawn_width / 2.0, spawn_width / 2.0)
		
		# Gán vị trí cách Player lên trên (âm Y) một đoạn spawn_height_offset
		var spawn_offset = Vector2(random_x, -spawn_height_offset)
		
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
