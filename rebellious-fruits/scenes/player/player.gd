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

@export_category("Gun Settings")
@export var bullet_count: int = 1         # Số lượng đạn bắn ra mỗi lần click
@export var bullet_speed: float = 800.0     # Tốc độ đạn
@export var bullet_spread: float = 15.0   # Độ tỏa (chùm) của đạn nếu bắn nhiều viên (độ)

var shoot_timer: float = 0.0
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
	if is_shooting:
		shoot_timer -= delta
		if shoot_timer <= 0:
			is_shooting = false
			# Ẩn tia lửa súng khi ngừng bắn
			var muzzle_flash = get_node_or_null("MuzzleFlash")
			if muzzle_flash:
				muzzle_flash.visible = false

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	var is_pressing_shoot = Input.is_action_pressed("click")
	
	if is_pressing_shoot or is_shooting:
		velocity.x = 0
	else:
		velocity.x = direction * SPEED

	if direction != 0 and not is_pressing_shoot and not is_shooting:
		anim.flip_h = direction < 0

	# Nhảy
	# Mới: Chỉ cho phép nhảy nếu không đè nút bắn (trên mặt đất)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_pressing_shoot:
		velocity.y = JUMP_FORCE
		_play_sfx(jump_sfx)

	# Bắn súng
	if is_pressing_shoot and not is_shooting:
		is_shooting = true

		var mouse_pos = get_global_mouse_position()
		var direction_bullet = (mouse_pos - global_position).normalized()

		anim.flip_h = mouse_pos.x < global_position.x
		var diff_y = mouse_pos.y - global_position.y
		var target_anim = "shoot_rapid_fire"
		if diff_y < -80:
			target_anim = "shoot_high"
		elif diff_y > 80:
			target_anim = "shoot_low"
			
		if anim.animation != target_anim:
			anim.play(target_anim)
			
		# Bật/Tắt Tia Lửa Đầu Súng
		var muzzle_flash = get_node_or_null("MuzzleFlash")
		if muzzle_flash:
			muzzle_flash.visible = (target_anim == "shoot_rapid_fire")
			
			var flash_sprite = muzzle_flash.get_node_or_null("AnimatedSprite2D")
			if not flash_sprite:
				flash_sprite = muzzle_flash.get_node_or_null("Sprite2D")
				
			if flash_sprite:
				flash_sprite.flip_h = anim.flip_h
			
			# Lật tia lửa dựa theo nhân vật (offset lại vị trí nếu cần)
			if anim.flip_h:
				muzzle_flash.position.x = -abs(muzzle_flash.position.x)
			else:
				muzzle_flash.position.x = abs(muzzle_flash.position.x)

		# Tính toán góc bắn chùm (Spread)
		var base_angle = direction_bullet.angle()
		var spread_rad = deg_to_rad(bullet_spread)
		
		var start_angle = base_angle
		if bullet_count > 1:
			start_angle = base_angle - (spread_rad / 2.0)
			
		var angle_step = 0.0
		if bullet_count > 1:
			angle_step = spread_rad / (bullet_count - 1)

		for i in range(bullet_count):
			var final_angle = start_angle + (angle_step * i)
			var final_dir = Vector2.RIGHT.rotated(final_angle)
			
			var bullet = bullet_scene.instantiate()
			get_parent().add_child(bullet)
			
			bullet.global_position = spawn_point.global_position
			bullet.direction = final_dir
			bullet.rotation = final_angle
			bullet.speed = bullet_speed # Gán tốc độ từ Inspector vào đạn

		_play_sfx(shoot_sfx)
		shoot_timer = 0.3

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
