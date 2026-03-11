extends Control

@onready var play_button: TextureButton = $VBoxContainer/PlayButton
@onready var settings_button: TextureButton = $VBoxContainer/SettingsButton
@onready var exit_button: TextureButton = $VBoxContainer/ExitButton

var settings_scene = preload("res://ui/menus/settings_menu.tscn")
var settings_instance = null

func _ready():
	AudioManager.play_music("menu_theme")
	
	_setup_button(play_button, _on_play_pressed)
	_setup_button(settings_button, _on_settings_pressed)
	_setup_button(exit_button, _on_exit_pressed)

func _setup_button(btn: TextureButton, callback: Callable):
	btn.pressed.connect(callback)
	
	# Hiệu ứng hover (phóng to nhẹ)
	btn.mouse_entered.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.1)
	)
	btn.mouse_exited.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	)
	
	# Hiệu ứng bấm (nhỏ lại và tối đi)
	btn.button_down.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(0.95, 0.95), 0.05)
		btn.modulate = Color(0.8, 0.8, 0.8)
	)
	btn.button_up.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.05)
		btn.modulate = Color(1, 1, 1)
	)

	# Đảm bảo pivot (tâm xoay/scale) nằm ở giữa nút
	btn.pivot_offset = btn.custom_minimum_size / 2.0
	if btn.size.x > 0:
		btn.pivot_offset = btn.size / 2.0


func _on_play_pressed():
	AudioManager.play_music("menu_theme")
	get_tree().change_scene_to_file("res://ui/roadmap/roadmap.tscn")

func _on_settings_pressed():
	if settings_instance == null:
		settings_instance = settings_scene.instantiate()
		add_child(settings_instance)
	else:
		settings_instance.visible = true

func _on_exit_pressed():
	get_tree().quit()
