extends Control

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var skip_button: Button = $SkipButton

func _ready():
	video_player.finished.connect(_on_video_finished)
	skip_button.pressed.connect(_on_skip_pressed)
	# Đảm bảo video bắt đầu phát
	video_player.play()

func _input(event):
	# Cho phép skip bằng phím Enter, Space hoặc Esc
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("click"):
		_on_skip_pressed()

func _on_video_finished():
	_go_to_main_menu()

func _on_skip_pressed():
	_go_to_main_menu()

func _go_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
