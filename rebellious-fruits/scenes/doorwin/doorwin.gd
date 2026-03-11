extends Area2D

@export var next_level_path: String = ""

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	# Bắt đầu hoạt ảnh nếu có
	var anim = get_node_or_null("AnimatedSprite2D")
	if anim:
		anim.play("idle")

func _on_body_entered(body):
	if body.is_in_group("player"):
		_go_to_next_level()

func _go_to_next_level():
	print("Chiến thắng! Quay về Roadmap.")
	get_tree().change_scene_to_file("res://ui/roadmap/roadmap.tscn")
