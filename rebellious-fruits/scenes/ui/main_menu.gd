extends Control

@onready var play_button: TextureButton = $VBoxContainer/PlayButton
@onready var settings_button: TextureButton = $VBoxContainer/SettingsButton
@onready var exit_button: TextureButton = $VBoxContainer/ExitButton

var settings_scene = preload("res://scenes/ui/settings_menu.tscn")
var settings_instance = null

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1/level_1_1.tscn")

func _on_settings_pressed():
	if settings_instance == null:
		settings_instance = settings_scene.instantiate()
		add_child(settings_instance)
	else:
		settings_instance.visible = true

func _on_exit_pressed():
	get_tree().quit()
