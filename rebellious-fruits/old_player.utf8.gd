extends CharacterBody2D

const SPEED = 200
const JUMP_FORCE = -550
const GRAVITY = 900

@onready var anim = $AnimatedSprite2D
@onready var spawn_points_parent = $BulletSpawnPoints
@onready var spawn_point = $BulletSpawnPoints/BulletSpawnPoint
@onready var spawn_high = $BulletSpawnPoints/SpawnHigh
@onready var spawn_high_medium = $BulletSpawnPoints/SpawnHighMedium
@onready var spawn_normal = $BulletSpawnPoints/SpawnNormal
@onready var spawn_low = $BulletSpawnPoints/SpawnLow
@onready var hud = $HUD
@onready var sfx_player = $SFXPlayer        # D├╣ng cho ├óm thanh ngß║»n (bß║»n, nhß║úy, chß║┐t, bß╗ï ─æ├ính)
@onready var sfx_loop = $SFXPlayerLoop      # D├╣ng cho ├óm thanh lß║╖p (chß║íy, ─æß╗⌐ng y├¬n, c├║i)

@export_category("Audio")
@export var shoot_sfx: AudioStream   # Tiß║┐ng bß║»n s├║ng
@export var jump_sfx: AudioStream    # Tiß║┐ng nhß║úy l├¬n
@export var run_sfx: AudioStream     # Tiß║┐ng chß║íy (lß║╖p)
@export var idle_sfx: AudioStream    # Tiß║┐ng ─æß╗⌐ng y├¬n thß╗ƒ (lß║╖p)
@export var crouch_sfx: AudioStream  # Tiß║┐ng c├║i xuß╗æng (lß║╖p)
@export var hit_sfx: AudioStream     # Tiß║┐ng bß╗ï tr├║ng ─æß║ín
@export var die_sfx: AudioStream     # Tiß║┐ng chß║┐t

@export_category("Gun Settings")
@export var bullet_damage: float = 10.0        # Lß╗▒c s├ít th╞░╞íng cß╗ºa ─æß║ín
@export var bullet_count: int = 1         # Sß╗æ l╞░ß╗úng ─æß║ín bß║»n ra mß╗ùi lß║ºn click
@export var bullet_speed: float = 800.0     # Tß╗æc ─æß╗Ö ─æß║ín
@export var bullet_spread: float = 15.0   # ─Éß╗Ö tß╗Åa (ch├╣m) cß╗ºa ─æß║ín nß║┐u bß║»n nhiß╗üu vi├¬n (─æß╗Ö)

@export_category("Dash Settings")
@export var dash_speed: float = 800.0     # Tß╗æc ─æß╗Ö l╞░ß╗¢t
@export var dash_duration: float = 0.2    # Thß╗¥i gian l╞░ß╗¢t

var is_dashing = false
var dash_timer = 0.0
var dash_direction = 0
var dash_velocity_2d = Vector2.ZERO

@export_category("Skills")
# Gß║»n cß╗⌐ng kß╗╣ n─âng v├áo Player, kh├┤ng cho ph├⌐p Level ─æ├¿ bß║╣p qua Inspector
var skill_q_scene: PackedScene = preload("res://scenes/player/skills/skill_q_effect.tscn")
var skill_e_scene: PackedScene = preload("res://scenes/player/skills/skill_e_effect.tscn")
var skill_r_scene: PackedScene = preload("res://scenes/player/skills/skill_r_effect.tscn")

# Cooldown gß╗æc
@export var skill_q_cooldown: float = 3.0
@export var skill_w_cooldown: float = 5.0
@export var skill_e_cooldown: float = 8.0
@export var skill_r_cooldown: float = 15.0

# Timer ─æß║┐m ng╞░ß╗úc (cooldown - ─æß║┐m tß╗½ max vß╗ü 0)
var skill_q_timer: float = 0.0
var skill_w_timer: float = 0.0
var skill_e_timer: float = 0.0
var skill_r_timer: float = 0.0

# Timer kß╗╣ n─âng W ─æang hoß║ít ─æß╗Öng (active duration)
var skill_w_active_timer: float = 0.0
var skill_w_active: bool = false  # true khi W ─æang c╞░ß╗¥ng h├│a tß╗æc ─æß╗Ö bß║»n

var is_casting_skill = false
var cast_timer: float = 0.0

var shoot_timer: float = 0.0
var is_shooting = false
var is_jump = false
var is_hit = false
var is_crouching = false
var health: float = 500.0
var score = 0
var bullet_scene = preload("res://scenes/player/player_bullet.tscn")

# Giß╗¢i hß║ín map
var limit_left_x: float = 0.0
var limit_right_x: float = 9999999.0

func _ready():
	if hud:
		hud.set_max_health(500)
		hud.update_health(health)
		hud.update_score(score)

func add_score(amount: int):
	score += amount
	if hud:
		hud.update_score(score)

func _physics_process(delta):
	# Trß╗½ thß╗¥i gian hß╗ôi chi├¬u
	if skill_q_timer > 0: skill_q_timer -= delta
	if skill_w_timer > 0: skill_w_timer -= delta
	if skill_e_timer > 0: skill_e_timer -= delta
	if skill_r_timer > 0: skill_r_timer -= delta
	
	# ─Éß║┐m ng╞░ß╗úc thß╗¥i gian W ─æang active (5s aura)
	if skill_w_active_timer > 0:
		skill_w_active_timer -= delta
		if hud:
			hud.update_skill_active("w", skill_w_active_timer, skill_w_cooldown)
		if skill_w_active_timer <= 0:
			_deactivate_w_effect()
	
	if is_casting_skill:
		cast_timer -= delta
		velocity.x = 0 # ─Éß╗⌐ng lß║íi khi cast skill
		velocity.y += GRAVITY * delta
		move_and_slide()
		if cast_timer <= 0:
			is_casting_skill = false
		return # Bß╗Å qua tß║Ñt cß║ú logic di chuyß╗ân/bß║»n s├║ng kh├íc khi ─æang cast skill
		
	# Xß╗¡ l├╜ thß╗¥i gian l╞░ß╗¢t
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			dash_velocity_2d = Vector2.ZERO
			# Kh├┤i phß╗Ñc tß╗æc ─æß╗Ö animation vß╗ü b├¼nh th╞░ß╗¥ng
			anim.speed_scale = 1.0
	if is_shooting:
		shoot_timer -= delta
		if shoot_timer <= 0:
			is_shooting = false
			# ß║¿n tia lß╗¡a s├║ng khi ngß╗½ng bß║»n
			var muzzle_flash = get_node_or_null("MuzzleFlash")
			if muzzle_flash:
				muzzle_flash.visible = false

	if not is_on_floor() and not is_dashing:
		velocity.y += GRAVITY * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	var is_pressing_shoot = Input.is_action_pressed("click")
	var is_just_pressing_shoot = Input.is_action_just_pressed("click")
	
	if is_pressing_shoot or is_shooting:
		velocity.x = 0
	elif is_dashing:
		if dash_velocity_2d != Vector2.ZERO: # L╞░ß╗¢t tß╗▒ do (Skill E)
			velocity = dash_velocity_2d
		else: # L╞░ß╗¢t ngang (Dash th╞░ß╗¥ng)
			velocity.x = dash_direction * dash_speed
			velocity.y = 0 # Khi l╞░ß╗¢t giß╗» nguy├¬n ─æß╗Ö cao
	else:
		velocity.x = direction * SPEED

	if direction != 0 and not is_pressing_shoot and not is_shooting and not is_dashing:
		anim.flip_h = direction < 0
		if anim.flip_h:
			spawn_points_parent.scale.x = -1
		else:
			spawn_points_parent.scale.x = 1

	# Nhß║úy
	# Mß╗¢i: Chß╗ë cho ph├⌐p nhß║úy nß║┐u kh├┤ng ─æ├¿ n├║t bß║»n (tr├¬n mß║╖t ─æß║Ñt) v├á kh├┤ng ─æang l╞░ß╗¢t
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_pressing_shoot and not is_dashing:
		velocity.y = JUMP_FORCE
		_play_sfx(jump_sfx)

	# Bß║»n s├║ng
	if is_pressing_shoot and not is_shooting and not is_dashing:
		is_shooting = true

		var mouse_pos = get_global_mouse_position()
		var direction_bullet = (mouse_pos - global_position).normalized()

		anim.flip_h = mouse_pos.x < global_position.x
		if anim.flip_h:
			spawn_points_parent.scale.x = -1
		else:
			spawn_points_parent.scale.x = 1
		
		# T├¡nh g├│c tß╗½ player ─æß║┐n chuß╗Öt (theo trß╗Ñc X ngang), ─æ╞ín vß╗ï degrees
		# Ch├║ ├╜: Y t─âng xuß╗æng, n├¬n g├│c ├óm = bß║»n l├¬n cao
		var delta_x = abs(mouse_pos.x - global_position.x)
		var delta_y = mouse_pos.y - global_position.y # ─üm = l├¬n cao
		var angle_deg = 0.0
		if delta_x > 0 or delta_y != 0:
			# ─æß╗Ö nghß╗ïng so vß╗¢i mß║╖t phß║│ng ngang. ├óm = h╞░ß╗¢ng l├¬n
			angle_deg = rad_to_deg(atan2(-delta_y, delta_x))
		
		var target_anim: String
		var active_spawn: Marker2D
		
		# Kh├┤ng cho bß║»n nß║┐u g├│c nß║▒m ngo├ái khoß║úng cho ph├⌐p (> 60┬░ hoß║╖c < -60┬░)
		if angle_deg > 60 or angle_deg < -60:
			is_shooting = false  # Hß╗ºy trß║íng th├íi bß║»n
		elif angle_deg > 20:
			# Bß║»n l├¬n ch├⌐o cao-trung b├¼nh (20┬░ - 60┬░)
			target_anim = "shoot_high_medium"
			active_spawn = spawn_high_medium
		elif angle_deg >= -15:
			# Bß║»n ngang hoß║╖c h╞íi ch├⌐o (-15┬░ - 20┬░)
			target_anim = "shoot"
			active_spawn = spawn_normal
		else:
			# Bß║»n ch├⌐o xuß╗æng (-60┬░ ─æß║┐n -15┬░)
			target_anim = "shoot_low"
			active_spawn = spawn_low
		
		if is_shooting and anim.animation != target_anim:
			anim.play(target_anim)
			anim.speed_scale = 2.5  # T─âng tß╗æc ─æß╗Ö animation khi bß║»n
			
		# Chß╗ë bß║»t ─æß║ºu bß║»n nß║┐u g├│c hß╗úp lß╗ç
		if is_shooting:
			# Bß║¡t/Tß║»t Tia Lß╗¡a ─Éß║ºu S├║ng
			var muzzle_flash = get_node_or_null("MuzzleFlash")
			if muzzle_flash:
				muzzle_flash.visible = (target_anim == "shoot_rapid_fire")
				
				var flash_sprite = muzzle_flash.get_node_or_null("AnimatedSprite2D")
				if not flash_sprite:
					flash_sprite = muzzle_flash.get_node_or_null("Sprite2D")
					
				if flash_sprite:
					flash_sprite.flip_h = anim.flip_h
				
				# Lß║¡t tia lß╗¡a dß╗▒a theo nh├ón vß║¡t (offset lß║íi vß╗ï tr├¡ nß║┐u cß║ºn)
				if anim.flip_h:
					muzzle_flash.position.x = -abs(muzzle_flash.position.x)
				else:
					muzzle_flash.position.x = abs(muzzle_flash.position.x)

			# T├¡nh to├ín g├│c bß║»n ch├╣m (Spread)
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
				
				bullet.global_position = active_spawn.global_position
				bullet.direction = final_dir
				bullet.rotation = final_angle
				bullet.speed = bullet_speed
				bullet.damage = bullet_damage

			_play_sfx(shoot_sfx)
			# Tß╗æc ─æß╗Ö bß║»n t─âng x2 khi W ─æang active
			shoot_timer = 0.15 if skill_w_active else 0.3

	# C├║i
	is_crouching = Input.is_action_pressed("crouch") and is_on_floor() and not is_dashing
	if is_crouching:
		velocity.x = 0

	if Input.is_action_just_pressed("skill_r"):
		print(">>> Phat hien ban phim go nut R! (is_shooting: ", is_shooting, ", is_on_floor: ", is_on_floor(), ", is_dashing: ", is_dashing, ")")

	# Nhß║¡n n├║t Kß╗╣ n─âng (Q, W, E, R)
	if is_on_floor() and not is_dashing and not is_shooting and not is_crouching:
		if Input.is_action_just_pressed("skill_q") and skill_q_timer <= 0:
			_cast_skill(skill_q_scene, skill_q_cooldown, "shoot_high_medium") # D├╣ng tß║ím animation bß║»n
			skill_q_timer = skill_q_cooldown
		elif Input.is_action_just_pressed("skill_w") and skill_w_timer <= 0:
			# Cast W internally (Aura directly on Player, lasts 5s)
			is_casting_skill = true
			cast_timer = 0.5
			anim.play("shoot_high")
			
			var w_effect = $SkillWEffect
			var w_anim = w_effect.get_node("AnimatedSprite2D")
			w_anim.visible = true
			w_anim.play("default")
			
			if anim.flip_h:
				w_anim.flip_h = true
			else:
				w_anim.flip_h = false
			
			# Bß║»t ─æß║ºu active duration 5s, ─æß║╖t cooldown sau khi hß║┐t
			skill_w_active_timer = skill_w_cooldown  # 5s active
			skill_w_timer = skill_w_cooldown * 2      # Tß╗òng cooldown = active + hß╗ôi
			skill_w_active = true  # K├¡ch hoß║ít t─âng tß╗æc bß║»n
			if hud:
				hud.set_skill_active("w")
		elif Input.is_action_just_pressed("skill_e") and skill_e_timer <= 0:
			# Kß╗╣ n─âng E: L╞░ß╗¢t NGANG theo ph├¡a chuß╗Öt tr├¬n trß╗Ñc X
			is_dashing = true
			dash_timer = dash_duration
			var mouse_pos = get_global_mouse_position()
			var h_dir = sign(mouse_pos.x - global_position.x) # Chß╗ë lß║Ñy h╞░ß╗¢ng ngang
			if h_dir == 0:
				h_dir = -1 if anim.flip_h else 1 # Fallback nß║┐u trß╗Å ngay giß╗»a ng╞░ß╗¥i
				
			dash_velocity_2d = Vector2(h_dir * dash_speed, 0)
			
			# Lß║¡t mß║╖t nh├ón vß║¡t theo h╞░ß╗¢ng l╞░ß╗¢t
			anim.flip_h = (h_dir < 0)
			if anim.flip_h:
				spawn_points_parent.scale.x = -1
			else:
				spawn_points_parent.scale.x = 1
				
			anim.speed_scale = 2.0
			anim.play("dash")
			_stop_loop_sfx()
			_play_sfx(run_sfx)
			skill_e_timer = skill_e_cooldown
		elif Input.is_action_just_pressed("skill_r") and skill_r_timer <= 0:
			_cast_skill(skill_r_scene, skill_r_cooldown, "shoot_rapid_fire")
			skill_r_timer = skill_r_cooldown

	# Nhß║¡n n├║t L╞░ß╗¢t (Dash)
	if Input.is_action_just_pressed("dash") and not is_dashing and not is_shooting and not is_crouching:
		is_dashing = true
		dash_timer = dash_duration
		dash_velocity_2d = Vector2.ZERO
		# L╞░ß╗¢t theo h╞░ß╗¢ng con trß╗Å chuß╗Öt nß║┐u kh├┤ng bß║Ñm h╞░ß╗¢ng, nß║┐u kh├┤ng th├¼ theo trß╗Ñc X (h╞░ß╗¢ng mß║╖t)
		dash_direction = -1 if anim.flip_h else 1
		# Nß║┐u ng╞░ß╗¥i ch╞íi bß║Ñm h╞░ß╗¢ng th├¼ l╞░ß╗¢t theo h╞░ß╗¢ng ─æang bß║Ñm
		if direction != 0:
			dash_direction = sign(direction)

		anim.speed_scale = 2.0 # Tß╗æc ─æß╗Ö animation x2
		anim.play("dash")
		_stop_loop_sfx()
		_play_sfx(run_sfx) # Hoß║╖c bß║ín c├│ thß╗â d├╣ng mß╗Öt sfx_dash ri├¬ng nß║┐u c├│

	# Animation + ├óm thanh trß║íng th├íi (looping)
	if not is_shooting and not is_hit and not is_dashing:
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
	
	# Ng─ân kh├┤ng cho nh├ón vß║¡t chß║íy ra khß╗Åi ranh giß╗¢i m├án h├¼nh
	if global_position.x < limit_left_x:
		global_position.x = limit_left_x
	elif global_position.x > limit_right_x:
		global_position.x = limit_right_x

# --- H├ám Cast Skill Chung ---
func _cast_skill(skill_scene: PackedScene, cooldown: float, cast_anim: String):
	is_casting_skill = true
	cast_timer = 0.5 # Thß╗¥i gian ─æß╗⌐ng y├¬n gß╗ông chi├¬u (c├│ thß╗â tuß╗│ chß╗ënh theo frame cß╗ºa anim)
	
	anim.play(cast_anim)
	
	if skill_scene:
		print(">>> Dang ban Skill: ", skill_scene.resource_path)
		var skill_instance = skill_scene.instantiate()
		get_parent().add_child(skill_instance)
		
		# Vß╗ï tr├¡ spawn tr╞░ß╗¢c mß║╖t player
		var offset_x = 80 if not anim.flip_h else -80
		skill_instance.global_position = global_position + Vector2(offset_x, -10)
		
		print(">>> Da them Skill vao Scene, Toa do: ", skill_instance.global_position)
		
		# Truyß╗ün h╞░ß╗¢ng mß║╖t v├áo Skill (nß║┐u skill c├│ hß╗ù trß╗ú lß║¡t h├¼nh)
		if skill_instance.get("is_player_facing_right") != null:
			skill_instance.is_player_facing_right = not anim.flip_h

# --- H├ám thiß║┐t lß║¡p Ranh Giß╗¢i (Nhß║¡n tß╗½ LevelBounds) ---
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

# --- H├ám ph├ít ├óm thanh ---
func _play_sfx(stream: AudioStream):
	if stream and sfx_player:
		sfx_player.stream = stream
		sfx_player.play()

func _play_loop_sfx(stream: AudioStream):
	if stream and sfx_loop:
		if sfx_loop.stream == stream and sfx_loop.playing:
			return  # ─Éang ph├ít rß╗ôi, kh├┤ng bß║¡t lß║íi
		sfx_loop.stream = stream
		sfx_loop.play()

func _stop_loop_sfx():
	if sfx_loop and sfx_loop.playing:
		sfx_loop.stop()

# --- Nhß║¡n s├ít th╞░╞íng ---
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
	# get_tree().reload_current_scene()  # Bß║¡t lß║íi khi cß║ºn

# --- Skill W Signals ---
func _on_skill_w_body_entered(body):
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(50.0)

func _on_skill_w_anim_finished():
	# Khi animation kß║┐t th├║c 1 lß║ºn, tß╗▒ play lß║íi nß║┐u c├▓n trong active duration
	var w_effect = $SkillWEffect
	if w_effect and skill_w_active_timer > 0:
		var w_anim = w_effect.get_node_or_null("AnimatedSprite2D")
		if w_anim:
			w_anim.play("default")

# Tß║»t hiß╗çu ß╗⌐ng W khi hß║┐t 5 gi├óy
func _deactivate_w_effect():
	skill_w_active = false  # Tß║»t t─âng tß╗æc bß║»n
	var w_effect = $SkillWEffect
	if w_effect:
		var w_anim = w_effect.get_node_or_null("AnimatedSprite2D")
		if w_anim:
			w_anim.visible = false
			w_anim.stop()
	if hud:
		hud.start_skill_cooldown("w", skill_w_cooldown)
