extends CharacterBody2D

const SPEED = 200
const JUMP_FORCE = -550
const GRAVITY = 900

@onready var anim = $AnimatedSprite2D
@onready var spawn_point = $BulletSpawnPoint
@onready var hud = $HUD
@onready var sfx_player = $SFXPlayer        # Dùng cho âm thanh ngắn (bắn, nhảy, chết, bị đánh)
@onready var sfx_loop = $SFXPlayerLoop      # Dùng cho âm thanh lặp (chạy, đứng yên, cúi)

@export_category("Audio")
@export var shoot_sfx: AudioStream   # Tiếng bắn súng
@export var jump_sfx: AudioStream    # Tiếng nhảy lên
@export var run_sfx: AudioStream     # Tiếng chạy (lặp)
@export var idle_sfx: AudioStream    # Tiếng đứng yên thở (lặp)
@export var crouch_sfx: AudioStream  # Tiếng cúi xuống (lặp)
@export var hit_sfx: AudioStream     # Tiếng bị trúng đạn
@export var die_sfx: AudioStream     # Tiếng chết

var is_shooting = false
var is_jump = false
var is_hit = false
var is_crouching = false
var health = 5
var score = 0
var bullet_scene = preload("res://scenes/player/player_bullet.tscn")

# Giới hạn map
var limit_left_x: float = 0.0
var limit_right_x: float = 9999999.0

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

	# Nhảy
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		_play_sfx(jump_sfx)

	# Bắn súng
	if Input.is_action_just_pressed("click") and not is_shooting:
		is_shooting = true

		var mouse_pos = get_global_mouse_position()
		var direction_bullet = (mouse_pos - global_position).normalized()

		anim.flip_h = mouse_pos.x < global_position.x
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
		bullet.direction = direction_bullet
		bullet.rotation = direction_bullet.angle()

		_play_sfx(shoot_sfx)

		await get_tree().create_timer(0.8).timeout
		is_shooting = false

	# Cúi
	is_crouching = Input.is_action_pressed("crouch") and is_on_floor()
	if is_crouching:
		velocity.x = 0

	# Animation + âm thanh trạng thái (looping)
	if not is_shooting and not is_hit:
		if is_crouching:
			if anim.animation != "crouch":
				anim.play("crouch")
				_play_loop_sfx(crouch_sfx)
		elif not is_on_floor():
			if anim.animation != "jump":
				anim.play("jump")
				_stop_loop_sfx()
		elif direction != 0:
			if anim.animation != "run":
				anim.play("run")
				_play_loop_sfx(run_sfx)
		else:
			if anim.animation != "idle":
				anim.play("idle")
				_play_loop_sfx(idle_sfx)

	move_and_slide()
	
	# Ngăn không cho nhân vật chạy ra khỏi ranh giới màn hình
	if global_position.x < limit_left_x:
		global_position.x = limit_left_x
	elif global_position.x > limit_right_x:
		global_position.x = limit_right_x

# --- Hàm thiết lập Ranh Giới (Nhận từ LevelBounds) ---
func set_left_bound(x_pos: float):
	limit_left_x = x_pos
	var cam = $Camera2D
	if cam:
		cam.limit_left = int(x_pos)

func set_right_bound(x_pos: float):
	limit_right_x = x_pos
	var cam = $Camera2D
	if cam:
		cam.limit_right = int(x_pos)

# --- Hàm phát âm thanh ---
func _play_sfx(stream: AudioStream):
	if stream and sfx_player:
		sfx_player.stream = stream
		sfx_player.play()

func _play_loop_sfx(stream: AudioStream):
	if stream and sfx_loop:
		if sfx_loop.stream == stream and sfx_loop.playing:
			return  # Đang phát rồi, không bật lại
		sfx_loop.stream = stream
		sfx_loop.play()

func _stop_loop_sfx():
	if sfx_loop and sfx_loop.playing:
		sfx_loop.stop()

# --- Nhận sát thương ---
func take_damage(amount):
	if is_hit:
		return
	health -= amount
	if hud:
		hud.update_health(health)

	is_hit = true
	anim.play("hit")
	_play_sfx(hit_sfx)
	await get_tree().create_timer(0.4).timeout
	is_hit = false
	if health <= 0:
		die()

func die():
	_play_sfx(die_sfx)
	print("Player 'died' but death is temporarily disabled for testing.")
	# get_tree().reload_current_scene()  # Bật lại khi cần
