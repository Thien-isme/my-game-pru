extends Control

@onready var video_rect: TextureRect = $VideoRect
@onready var skip_button: Button = $SkipButton
@onready var audio_player: AudioStreamPlayer = $AudioPlayer

var frames: Array[Texture2D] = []
var current_frame_index: int = 0
var fps: float = 24.0
var time_per_frame: float = 1.0 / fps
var time_accumulator: float = 0.0
var is_playing: bool = false
var dir_path: String = "res://assets/ui/video_frames/"

func _ready():
	skip_button.pressed.connect(_on_skip_pressed)
	# Tải toàn bộ ảnh lên bộ nhớ RAM khi bật game
	_load_frames()
	
	if frames.size() > 0:
		video_rect.texture = frames[0]
		is_playing = true
		if audio_player.stream != null:
			audio_player.play()
	else:
		print("Không tìm thấy ảnh frame nào trong ", dir_path)
		_go_to_main_menu()

func _load_frames():
	# Vì trong bản build (export), DirAccess không thể liệt kê các file đã được remapped (.png -> .png.import)
	# Chúng ta sẽ nạp trực tiếp theo tên file vì biết rõ số lượng (192 frames) và quy tắc đặt tên (001 -> 192)
	var total_frames = 192
	for i in range(1, total_frames + 1):
		# Định dạng số thứ tự thành 3 chữ số (ví dụ: 1 -> "001", 10 -> "010")
		var frame_num = str(i).pad_zeros(3)
		var file_path = dir_path + "ezgif-frame-" + frame_num + ".png"
		
		# Load texture trực tiếp. Godot sẽ tự động xử lý việc tìm file .import trong bản build
		if ResourceLoader.exists(file_path):
			var tex = load(file_path)
			if tex:
				frames.append(tex)
		else:
			# Chỉ in lỗi nếu không tìm thấy frame đầu tiên (để tránh spam log nếu thiếu file)
			if i == 1:
				print("Intro: Không tìm thấy frame đầu tiên tại: ", file_path)
	
	if frames.size() == 0:
		print("Intro: Không nạp được bất kỳ frame nào từ: ", dir_path)

func _process(delta: float):
	if not is_playing or frames.size() == 0:
		return
		
	time_accumulator += delta
	
	# Tính toán chạy slide show theo tốc độ 24fps
	while time_accumulator >= time_per_frame:
		time_accumulator -= time_per_frame
		current_frame_index += 1
		
		# Nếu đã lật tới tấm ảnh cuối cùng
		if current_frame_index >= frames.size():
			is_playing = false
			_go_to_main_menu()
			return
		
		# Cập nhật hình ảnh hiển thị trên giao diện
		video_rect.texture = frames[current_frame_index]

func _input(event):
	# Cho phép bỏ qua khi ấn phím Enter, Esc, Space hoặc Trái chuột
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("click"):
		_on_skip_pressed()

func _on_skip_pressed():
	is_playing = false
	_go_to_main_menu()

func _go_to_main_menu():
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
