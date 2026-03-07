extends CharacterBody2D

@export var speed = 80.0
@export var health = 3
@export var shoot_cooldown = 2.0
@export var bullet_scene: PackedScene  # Chỉnh trong Inspector cho từng enemy
@export var bullet_speed: float = 300.0

var player = null
var can_shoot = true
var is_attacking = false

var detect_radius: float = 0.0 # Will be populated by spawner
var attack_radius: float = 0.0 # Will be populated by spawner

@onready var anim = $AnimatedSprite2D

const GRAVITY = 900

func _ready():
	if detect_radius > 0 and has_node("DetectZone/CollisionShape2D"):
		var d_shape = $DetectZone/CollisionShape2D.shape as CircleShape2D
		if d_shape:
			d_shape.radius = detect_radius
			
	if attack_radius > 0 and has_node("AttackZone/CollisionShape2D"):
		var a_shape = $AttackZone/CollisionShape2D.shape as CircleShape2D
		if a_shape:
			a_shape.radius = attack_radius

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
		if can_shoot and bullet_scene != null:
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
	if "speed" in bullet:
		bullet.speed = bullet_speed
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
