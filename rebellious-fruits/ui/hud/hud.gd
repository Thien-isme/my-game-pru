extends CanvasLayer

@onready var health_bar = $TopCenter/HealthBar
@onready var score_label = $ScoreLabel
@onready var skill_q_panel = $BottomCenter/SkillQ
@onready var skill_w_panel = $BottomCenter/SkillW
@onready var skill_e_panel = $BottomCenter/SkillE
@onready var skill_r_panel = $BottomCenter/SkillR

var max_health: float = 500.0
var current_health: float = 500.0
var score: int = 0

# Trạng thái cooldown của mỗi kỹ năng
var skill_cooldowns = {"q": 0.0, "w": 0.0, "e": 0.0, "r": 0.0}
var skill_max_cooldowns = {"q": 3.0, "w": 5.0, "e": 8.0, "r": 15.0}
var skill_active = {"q": false, "w": false, "e": false, "r": false}

func _ready():
	_update_ui()

func set_max_health(value: float):
	max_health = value
	if health_bar:
		health_bar.max_value = value
	_update_ui()

func update_health(health: float):
	current_health = health
	_update_ui()

func update_score(new_score: int):
	score = new_score
	_update_ui()

func _update_ui():
	if health_bar:
		health_bar.value = current_health
		_update_health_color()
	if score_label:
		score_label.text = "Score: " + str(score)

func _update_health_color():
	var percent = current_health / max_health
	var fill_style = health_bar.get_theme_stylebox("fill").duplicate()
	if percent > 0.8:
		fill_style.bg_color = Color(0.1, 0.8, 0.1)    # Xanh lá
	elif percent > 0.3:
		fill_style.bg_color = Color(0.9, 0.6, 0.1)    # Vàng cam
	else:
		fill_style.bg_color = Color(0.8, 0.1, 0.1)    # Đỏ
	health_bar.add_theme_stylebox_override("fill", fill_style)

# --- Gọi khi kỹ năng được kích hoạt (đang active) ---
func set_skill_active(skill_key: String):
	skill_active[skill_key] = true
	_refresh_skill_panel(skill_key)

# --- Gọi mỗi frame khi W đang active, để cập nhật thanh active ---
func update_skill_active(skill_key: String, remaining: float, total: float):
	var panel = _get_skill_panel(skill_key)
	if not panel: return
	var overlay = panel.get_node_or_null("CooldownOverlay")
	if overlay:
		# Khi đang active: overlay sáng vàng, độ mờ giảm dần
		overlay.active_ratio = 1.0 - (remaining / total)
		overlay.is_active_phase = true
		overlay.queue_redraw()

# --- Gọi khi bắt đầu cooldown (sau khi W hết 5s) ---
func start_skill_cooldown(skill_key: String, cool_time: float):
	skill_active[skill_key] = false
	_refresh_skill_panel(skill_key)
	skill_cooldowns[skill_key] = cool_time
	skill_max_cooldowns[skill_key] = cool_time
	var panel = _get_skill_panel(skill_key)
	if panel:
		var overlay = panel.get_node_or_null("CooldownOverlay")
		if overlay:
			overlay.is_active_phase = false
			overlay.queue_redraw()

func _process(delta):
	# Đếm ngược cooldown cho mỗi kỹ năng và cập nhật overlay
	for key in skill_cooldowns:
		if skill_cooldowns[key] > 0:
			skill_cooldowns[key] -= delta
			if skill_cooldowns[key] <= 0:
				skill_cooldowns[key] = 0
			_update_skill_cooldown_overlay(key)

func _update_skill_cooldown_overlay(skill_key: String):
	var panel = _get_skill_panel(skill_key)
	if not panel: return
	var overlay = panel.get_node_or_null("CooldownOverlay")
	if overlay:
		var max_cd = skill_max_cooldowns[skill_key]
		if max_cd > 0:
			overlay.cooldown_ratio = skill_cooldowns[skill_key] / max_cd
		else:
			overlay.cooldown_ratio = 0.0
		overlay.is_active_phase = false
		overlay.queue_redraw()

func _refresh_skill_panel(skill_key: String):
	var panel = _get_skill_panel(skill_key)
	if not panel: return
	var style = panel.get_theme_stylebox("panel").duplicate()
	if skill_active[skill_key]:
		style.border_color = Color(1.0, 0.9, 0.0, 1.0) # Vàng sáng khi active
	else:
		style.border_color = Color(0.678, 0.11, 0.11, 1.0) # Đỏ đậm mặc định
	panel.add_theme_stylebox_override("panel", style)

func _get_skill_panel(key: String) -> Panel:
	match key:
		"q": return skill_q_panel
		"w": return skill_w_panel
		"e": return skill_e_panel
		"r": return skill_r_panel
	return null
