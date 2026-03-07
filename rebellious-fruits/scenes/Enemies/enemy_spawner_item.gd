@tool
extends Marker2D

@export_category("Enemy Settings")
@export var enemy_scene: PackedScene

@export var max_enemies: int = 1
@export var spawn_interval: float = 5.0

@export_category("Enemy Stats Overrides")
@export var override_shoot_cooldown: float = 0.0
@export var override_bullet_speed: float = 0.0

@export_group("Enemy Area Previews (Editor Only)")
@export var override_detect_radius: float = 0.0 :
	set(value):
		override_detect_radius = value
		queue_redraw()
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
