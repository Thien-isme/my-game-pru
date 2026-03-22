extends Control

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var skip_button: Button = $SkipButton

func _ready():
	skip_button.pressed.connect(_on_skip_pressed)
	# Kết nối signal finished để tự động chuyển sang main menu khi video kết thúc
	video_player.finished.connect(_go_to_main_menu)
	video_player.play()

func _input(event):
	# Cho phép bỏ qua khi ấn phím Enter, Esc, Space hoặc Trái chuột
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("click"):
		_on_skip_pressed()

func _on_skip_pressed():
	video_player.stop()
	_go_to_main_menu()

func _go_to_main_menu():
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
