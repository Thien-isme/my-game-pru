extends Area2D  
# (hoặc CharacterBody2D nếu bullet của bạn là CharacterBody2D)

var direction = Vector2.RIGHT
var speed = 300.0
var damage = 1

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)  # Gọi hàm nhận damage của player
		queue_free()              # Xóa đạn sau khi trúng
	elif body is TileMapLayer:
		queue_free()              # Xóa đạn khi chạm tường
