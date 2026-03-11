extends Area2D

@export var speed: float = 400.0
@export var damage: float = 30.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_exploding: bool = false
var direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	# Bắt đầu với animation bay
	if anim:
		anim.play("fly")
	
	# Kết nối tín hiệu va chạm
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if is_exploding:
		return
	
	# Bay theo hướng direction
	position += direction * speed * delta
	
	# Xoay toàn bộ Rocket theo hướng bay (cộng 90 độ vì hình gốc chĩa thẳng lên trên)
	rotation = direction.angle() + (PI / 2.0)

func _on_body_entered(body: Node2D) -> void:
	if is_exploding:
		return
		
	# Gây sát thương nếu chạm người chơi
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		_explode()

func _explode() -> void:
	is_exploding = true
	
	if anim and anim.sprite_frames.has_animation("explode"):
		anim.play("explode")
		# Xóa bỏ các góc xoay và vị trí lệch lúc bay (giúp vụ nổ nằm ngay tâm)
		rotation = 0
		anim.rotation = 0
		# Trả vị trí của Sprite về tâm 0,0 để khớp với điểm va chạm
		anim.position = Vector2.ZERO
		
		await anim.animation_finished
	
	queue_free()
