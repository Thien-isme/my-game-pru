@tool
extends Node2D

@export var enemy_scene: PackedScene
@export var max_enemies: int = 3
@export var spawn_interval: float = 2.0

@export_category("Spawner Area Settings")
## Kích thước vùng nhận diện người chơi
@export var detect_size: Vector2 = Vector2(800, 600):
	set(value):
		detect_size = value
		_update_detect_shape()

## Vị trí quái vật sinh ra (so với tâm của spawner)
@export var spawn_offset: Vector2 = Vector2.ZERO:
	set(value):
		spawn_offset = value
		_update_spawn_point()


var spawned_count: int = 0
var is_player_near: bool = false
var spawn_timer: Timer

@onready var spawn_point = $SpawnPoint
@onready var detect_shape = $DetectArea/CollisionShape2D

func _ready():
	_update_detect_shape()
	_update_spawn_point()
	
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
		
func _update_spawn_point():
	if not is_node_ready():
		return
	if spawn_point:
		spawn_point.position = spawn_offset

func _on_detect_area_body_entered(body):
	if Engine.is_editor_hint(): return
	if body.is_in_group("player"):
		is_player_near = true
		if spawn_timer.is_stopped() and spawned_count < max_enemies:
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
		spawned_count += 1

