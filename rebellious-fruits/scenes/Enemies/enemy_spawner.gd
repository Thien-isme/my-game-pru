@tool
extends Node2D

@export var enemy_scene: PackedScene
@export var max_enemies: int = 3
@export var spawn_interval: float = 2.0

@export_category("Spawner Area Settings")
## Kích thước vùng nhận diện người chơi
@export var detect_size: Vector2 = Vector2(920, 645):
	set(value):
		detect_size = value
		_update_detect_shape()

@export_category("Enemy Stats Overrides")
## Chỉnh tốc độ bắn riệng cho bầy quái này (để 0 thì xài mặc định của quái)
@export var override_shoot_cooldown: float = 0.0
## Chỉnh tốc độ đạn riêng cho bầy quái này (để 0 thì xài mặc định của đạn)
@export var override_bullet_speed: float = 0.0

@export_group("Enemy Area Previews (Editor Only)")
## Chỉnh vùng Detect của bầy quái (để 0 thì xài vùng mặc định của quái - chỉ hiển thị để làm chuẩn)
@export var override_detect_radius: float = 0.0 :
	set(value):
		override_detect_radius = value
		queue_redraw()
## Chỉnh vùng Attack của bầy quái (để 0 thì xài vùng mặc định của quái - chỉ hiển thị để làm chuẩn)
@export var override_attack_radius: float = 0.0 :
	set(value):
		override_attack_radius = value
		queue_redraw()



var spawned_count: int = 0
var is_player_near: bool = false
var spawn_timer: Timer

@onready var spawn_point = $SpawnPoint
@onready var detect_shape = $DetectArea/CollisionShape2D

func _ready():
	_update_detect_shape()
	
	if Engine.is_editor_hint():
		return # Không chạy logic game trong editor

	# Tạo Timer bằng code để quản lý thời gian spawn
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

func _update_detect_shape():
	if not is_node_ready():
		return
	if detect_shape and detect_shape.shape is RectangleShape2D:
		detect_shape.shape.size = detect_size
		
func _draw():
	if Engine.is_editor_hint():
		if override_detect_radius > 0:
			draw_circle(spawn_point.position, override_detect_radius, Color(0.1, 0.8, 0.8, 0.2))
		if override_attack_radius > 0:
			draw_circle(spawn_point.position, override_attack_radius, Color(0.9, 0.1, 0.3, 0.3))

func _on_detect_area_body_entered(body):
	if Engine.is_editor_hint(): return
	if body.is_in_group("player"):
		is_player_near = true
		if spawn_timer.is_stopped() and spawned_count < max_enemies:
			_on_spawn_timer_timeout() # Gọi ngay để đẻ 1 con lập tức khi Player dẫm vào vùng xanh
			if spawned_count < max_enemies: # Nếu vẫn còn quái cần đẻ thì mới bật Timer
				spawn_timer.start()

func _on_detect_area_body_exited(body):
	if Engine.is_editor_hint(): return
	if body.is_in_group("player"):
		is_player_near = false
		spawn_timer.stop()

func _on_spawn_timer_timeout():
	if Engine.is_editor_hint(): return
	if spawned_count >= max_enemies:
		spawn_timer.stop()
		return
		
	if enemy_scene and is_player_near:
		var enemy = enemy_scene.instantiate()
		
		# Tìm node Entities/Enemies trong Level để gom chung kẻ địch thay vì làm con của Spawner
		var parent_node = get_tree().current_scene.find_child("Enemies", true, false)
		if parent_node:
			parent_node.add_child(enemy)
		else:
			get_tree().current_scene.add_child(enemy)
			
		enemy.global_position = spawn_point.global_position
		
		# Áp dụng các thông số nghi đè nếu có
		if override_shoot_cooldown > 0.0 and "shoot_cooldown" in enemy:
			enemy.shoot_cooldown = override_shoot_cooldown
		if override_bullet_speed > 0.0 and "bullet_speed" in enemy:
			enemy.bullet_speed = override_bullet_speed
		
		# Set custom radius from Spawner into actual script variables if the enemy has them
		if override_detect_radius > 0.0 and "detect_radius" in enemy:
			enemy.detect_radius = override_detect_radius
		if override_attack_radius > 0.0 and "attack_radius" in enemy:
			enemy.attack_radius = override_attack_radius
			
		spawned_count += 1
