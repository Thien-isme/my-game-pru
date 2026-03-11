extends CanvasLayer

func _ready():
	# Menu tạm dừng luôn xử lý kể cả khi game đang pause
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_cancel_pressed():
	print("PauseMenu: Cancel pressed")
	get_tree().paused = false
	queue_free()

func _on_exit_pressed():
	print("PauseMenu: Exit pressed")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/roadmap/roadmap.tscn")
	queue_free()

func _input(event):
	# Nếu đang pause mà nhấn ESC lần nữa thì resume
	if event.is_action_pressed("ui_cancel"):
		_on_cancel_pressed()
		get_viewport().set_input_as_handled()
