extends Area2D
class_name BaseSkillEffect

# Các thông số có thể tinh chỉnh cho từng skill
@export var damage: float = 20.0
@export var is_player_facing_right: bool = true

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Gắn tín hiệu khi có người/quái đi vào vùng sát thương
	body_entered.connect(_on_body_entered)
	
	if anim:
		# Gắn tín hiệu chạy xong animation thì tự hủy
		anim.animation_finished.connect(_on_animation_finished)
		anim.play() # Tự động chạy animation mặc định
		
		# Lật hình ảnh (VFX) dựa theo hướng đứng của Player
		if not is_player_facing_right:
			anim.flip_h = true
			# Lật vùng sát thương (nếu nó không nằm ở tọa độ 0,0)
			position.x = -abs(position.x)
		else:
			anim.flip_h = false
			position.x = abs(position.x)

func _on_body_entered(body: Node2D):
	# Nếu đối tượng chạm vào thuộc nhóm "enemy" và có hàm take_damage
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(damage)

func _on_animation_finished():
	# Hoạt ảnh hiệu ứng kết thúc -> tự xóa
	queue_free()
