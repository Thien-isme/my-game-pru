extends CharacterBody2D

@export var speed = 80.0
@export var health = 3
@export var shoot_cooldown = 2.0
@export var bullet_scene: PackedScene  # Chỉnh trong Inspector cho từng enemy
@export var bullet_speed: float = 300.0

@export_category("Patrol Settings")
@export var patrol_distance: float = 100.0 # Khoảng cách đi tuần mỗi bên (để 0 nếu muốn đứng im)
@export var patrol_speed: float = 40.0   # Tốc độ đi tuần (chậm hơn speed rượt đuổi)
@export var patrol_wait_time: float = 1.5 # Thời gian đứng ngó nghiêng ở mỗi đầu

@export_category("Audio")
@export var shoot_sfx: AudioStream  # Tiếng bắn đạn - kéo thả file âm thanh vào đây
@export var die_sfx: AudioStream    # Tiếng chết - kéo thả file âm thanh vào đây
@export var explode_sfx: AudioStream  # Tiếng đạn trúng player - kéo thả file âm thanh vào đây

var player = null
var can_shoot = true
var is_attacking = false

var detect_radius: float = 0.0 # Will be populated by spawner
var attack_radius: float = 0.0 # Will be populated by spawner

# Biến dùng cho đi tuần
var start_x: float = 0.0
var patrol_target_x: float = 0.0
var patrol_dir: int = 1
var is_patrol_waiting: bool = false

@onready var anim = $AnimatedSprite2D
@onready var sfx_player = $SFXPlayer

const GRAVITY = 900

func _ready():
	start_x = global_position.x
	patrol_target_x = start_x + patrol_distance * patrol_dir
	
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
		if patrol_distance <= 0:
			velocity.x = 0
			anim.play("idle")
		else:
			_patrol_update()
			
		move_and_slide()
		return

	# Reset trạng thái tuần tra khi thấy người chơi để lúc mất dấu nó không bị kẹt
	is_patrol_waiting = false

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

# --- Logic Tuần Tra ---
func _patrol_update():
	if is_patrol_waiting:
		velocity.x = 0
		anim.play("idle")
		return
		
	# Di chuyển tới mục tiêu
	velocity.x = patrol_dir * patrol_speed
	anim.flip_h = patrol_dir < 0
	anim.play("run")
	
	# Kiểm tra xem đã đến đích chưa
	var reached_target = false
	if patrol_dir == 1 and global_position.x >= patrol_target_x:
		reached_target = true
	elif patrol_dir == -1 and global_position.x <= patrol_target_x:
		reached_target = true
		
	# Hoặc bị vướng tường
	if is_on_wall():
		reached_target = true
		
	if reached_target:
		_start_patrol_wait()

func _start_patrol_wait():
	is_patrol_waiting = true
	velocity.x = 0
	anim.play("idle")
	
	# Tính trước điểm đến tiếp theo
	patrol_dir *= -1
	patrol_target_x = start_x + patrol_distance * patrol_dir
	
	await get_tree().create_timer(patrol_wait_time).timeout
	is_patrol_waiting = false

func _shoot():
	can_shoot = false
	
	# Phát tiếng bắn
	_play_sfx(shoot_sfx)
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = (player.global_position - global_position).normalized()
	
	# Xoay viên đạn theo hướng bay. 
	bullet.rotation = bullet.direction.angle()
	
	# Truyền bản thân enemy vào viên đạn để đạn có thể mượn loa phát tiếng nổ
	if "shooter" in bullet:
		bullet.shooter = self
	
	if "speed" in bullet:
		bullet.speed = bullet_speed
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		_die()

func _die():
	# Phát tiếng chết trước khi xóa
	_play_sfx(die_sfx)
	queue_free()

func play_explode_sfx():
	# Gọi hàm này từ bullet khi nó trúng player để phát tiếng nổ
	_play_sfx(explode_sfx)

func _play_sfx(stream: AudioStream):
	if stream and sfx_player:
		sfx_player.stream = stream
		sfx_player.play()

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
