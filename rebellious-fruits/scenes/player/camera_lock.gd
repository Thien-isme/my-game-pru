extends Camera2D

var initial_y: float

func _ready():
	# Lưu lại tọa độ Y thực tế trên Level lúc vừa bắt đầu game
	initial_y = global_position.y

func _process(_delta):
	# Ép Camera luôn nằm ở tọa độ Y ban đầu, kệ xác Player nhảy đi đâu
	global_position.y = initial_y
