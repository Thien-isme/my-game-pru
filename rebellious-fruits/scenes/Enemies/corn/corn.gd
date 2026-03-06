extends CharacterBody2D

@export var speed = 80.0
@export var health = 3
@export var shoot_cooldown = 2.0

var bullet_scene = preload("res://scenes/enemies/corn/corn_bullet.tscn")

var player = null
var can_shoot = true
var is_attacking = false

@onready var anim = $AnimatedSprite2D

const GRAVITY = 900

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if player == null:
		velocity.x = 0
		anim.play("idle")
		move_and_slide()
		return

	if is_attacking:
		# Trong tầm bắn → đứng yên và bắn
		velocity.x = 0
		anim.flip_h = player.global_position.x < global_position.x
		anim.play("shoot")
		if can_shoot:
			_shoot()
	else:
		# Thấy player nhưng chưa trong tầm bắn → đuổi theo
		var dir = sign(player.global_position.x - global_position.x)
		velocity.x = dir * speed
		anim.flip_h = dir < 0
		anim.play("run")

	move_and_slide()

func _shoot():
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = (player.global_position - global_position).normalized()
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

# --- Signals từ DetectZone ---
func _on_detect_zone_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_detect_zone_body_exited(body):
	if body.is_in_group("player"):
		player = null

# --- Signals từ AttackZone ---
func _on_attack_zone_body_entered(body):
	if body.is_in_group("player"):
		is_attacking = true

func _on_attack_zone_body_exited(body):
	if body.is_in_group("player"):
		is_attacking = false
