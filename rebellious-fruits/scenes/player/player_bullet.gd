extends Area2D

var direction = Vector2.RIGHT
var speed = 400.0
var damage = 1

@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("fly")  # Bắt đầu với animation bay

func _physics_process(delta):
	position += direction * speed * delta

func hit_enemy(enemy):
	# Tắt di chuyển và collision
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Chơi animation explode
	anim.play("explode")
	
	# Gây damage cho enemy
	# enemy.take_damage(damage)  ← Nếu enemy có hàm này
	
	# Chờ animation xong rồi xóa đạn
	await anim.animation_finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		hit_enemy(body)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
