extends CanvasLayer

func _ready():
	# Đảm bảo UI này luôn hiển thị trên cùng và ngắt input của game bên dưới
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Tạm dừng game khi hiện Game Over (tùy chọn, ở đây người dùng yêu cầu idle nên có thể không cần pause toàn bộ)
	# get_tree().paused = true 

func _on_retry_pressed():
	print("GameOver: Retry pressed")
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()

func _on_menu_pressed():
	print("GameOver: Menu pressed")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/roadmap/roadmap.tscn")
	queue_free()
