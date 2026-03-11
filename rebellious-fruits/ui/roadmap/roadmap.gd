extends Control

@onready var buttons_container = $LevelButtons

func _ready():
	_setup_level_buttons()
	AudioManager.play_music("menu_theme")

func _setup_level_buttons():
	for i in range(buttons_container.get_child_count()):
		var btn = buttons_container.get_child(i)
		if btn is TextureButton:
			var level_num = i + 1
			btn.pressed.connect(_on_level_pressed.bind(level_num))
			_setup_button_hover(btn)

func _setup_button_hover(btn: TextureButton):
	btn.pivot_offset = btn.size / 2.0
	btn.mouse_entered.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1)
	)
	btn.mouse_exited.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	)

func _on_level_pressed(level_num: int):
	var scene_path = "res://scenes/levels/level_1/level_1_" + str(level_num) + ".tscn"
	if FileAccess.file_exists(scene_path):
		AudioManager.play_music("level1_theme")
		get_tree().change_scene_to_file(scene_path)
	else:
		print("Roadmap: Level scene not found: ", scene_path)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
