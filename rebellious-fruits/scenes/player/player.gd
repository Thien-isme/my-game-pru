extends CharacterBody2D

const SPEED = 200
const JUMP_FORCE = -550
const GRAVITY = 900

@onready var anim = $AnimatedSprite2D
@onready var spawn_point = $BulletSpawnPoint
@onready var hud = $HUD

var is_shooting = false
var is_jump = false
var is_hit = false
var is_crouching = false
var health = 5  # Máu của player
var score = 0
var bullet_scene = preload("res://scenes/player/player_bullet.tscn")

func _ready():
	if hud:
		hud.set_max_health(5)
		hud.update_health(health)
		hud.update_score(score)

func add_score(amount: int):
	score += amount
	if hud:
		hud.update_score(score)


func _physics_process(delta):

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if direction != 0:
		anim.flip_h = direction < 0

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	# shoot
	if Input.is_action_just_pressed("click") and not is_shooting:
		is_shooting = true
		
		var mouse_pos = get_global_mouse_position()
		var direction_bullet = (mouse_pos - global_position).normalized()
		
		anim.flip_h = mouse_pos.x < global_position.x
		#Chọn animation dựa vào hướng chuột
		var diff_y = mouse_pos.y - global_position.y
		if diff_y < -80:
			anim.play("shoot_high")
		elif diff_y > 80:
			anim.play("shoot_low")
		else:
			anim.play("shoot")
	
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = spawn_point.global_position
		bullet.direction = direction_bullet  # ← Đúng rồi! direction_bullet là Vector2
		# Xoay toàn bộ bullet theo hướng bắn
		bullet.rotation = direction_bullet.angle()

		await get_tree().create_timer(0.8).timeout
		is_shooting = false

# crouch
	is_crouching = Input.is_action_pressed("crouch") and is_on_floor()
	if is_crouching:
		velocity.x = 0  # Đứng yên khi cúi
		
	# animation
	# animation
	if not is_shooting and not is_hit:
		if is_crouching:
			if anim.animation != "crouch":   # ← Chỉ play nếu chưa đang chạy
				anim.play("crouch")
		elif not is_on_floor():
			if anim.animation != "jump":
				anim.play("jump")
		elif direction != 0:
			if anim.animation != "run":
				anim.play("run")
		else:
			if anim.animation != "idle":
				anim.play("idle")




	move_and_slide()
	
func take_damage(amount):
	if is_hit:  # Tránh bị hit nhiều lần cùng lúc
		return
	health -= amount
	if hud:
		hud.update_health(health)
	
	is_hit = true
	anim.play("hit")                          # Phát animation hit
	await get_tree().create_timer(0.4).timeout  # Chờ animation xong
	is_hit = false
	if health <= 0:
		die()

func die():
	get_tree().reload_current_scene()  # Reload level khi chết
