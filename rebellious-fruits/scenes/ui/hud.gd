extends CanvasLayer

@onready var health_bar = $MarginContainer/VBoxContainer/HealthBar
@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel

var max_health: int = 5
var current_health: int = 5
var score: int = 0

func _ready():
	_update_ui()

func set_max_health(value: int):
	max_health = value
	health_bar.max_value = value
	_update_ui()

func update_health(health: int):
	current_health = health
	_update_ui()

func update_score(new_score: int):
	score = new_score
	_update_ui()

func _update_ui():
	if health_bar:
		health_bar.value = current_health
	if score_label:
		score_label.text = "Score: " + str(score)
