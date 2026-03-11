extends Area2D

@export var next_level_path: String = ""

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	# Bắt đầu hoạt ảnh nếu có
	var anim = get_node_or_null("AnimatedSprite2D")
	if anim:
		anim.play("idle")

func _on_body_entered(body):
	if body.is_in_group("player"):
		_go_to_next_level()

func _go_to_next_level():
	# Ưu tiên path được gán tay trong Inspector
	if next_level_path != "" and FileAccess.file_exists(next_level_path):
		get_tree().change_scene_to_file(next_level_path)
		return

	# Nếu không gán, tự động tìm level tiếp theo dựa trên tên file hiện tại
	var current_scene_path = get_tree().current_scene.scene_file_path
	# Định dạng dự kiến: res://scenes/levels/level_1/level_1_1.tscn
	
	var regex = RegEx.new()
	# Tìm số cuối cùng trước dấu chấm .tscn
	regex.compile("(\\d+)\\.tscn$")
	var result = regex.search(current_scene_path)
	
	if result:
		var current_num_str = result.get_string(1)
		var current_num = int(current_num_str)
		var next_num = current_num + 1
		
		# Tạo đường dẫn mới bằng cách thay thế số cũ bằng số mới
		var next_scene_path = current_scene_path.replace(current_num_str + ".tscn", str(next_num) + ".tscn")
		
		if FileAccess.file_exists(next_scene_path):
			print("Cổng dịch chuyển: Chuyển sang màn ", next_num)
			get_tree().change_scene_to_file(next_scene_path)
		else:
			print("Cổng dịch chuyển: Không tìm thấy màn ", next_num, ". Quay về Menu.")
			get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
