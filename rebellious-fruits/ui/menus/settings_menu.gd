extends CanvasLayer

@onready var music_slider: HSlider = $CenterContainer/TextureRect/VBoxSettings/MusicHBox/MusicSlider
@onready var sfx_slider: HSlider = $CenterContainer/TextureRect/VBoxSettings/SFXHBox/SFXSlider
@onready var master_slider: HSlider = $CenterContainer/TextureRect/VBoxSettings/MasterHBox/MasterSlider

@onready var apply_btn: TextureButton = $CenterContainer/TextureRect/HBoxButtons/ApplyButton
@onready var cancel_btn: TextureButton = $CenterContainer/TextureRect/HBoxButtons/CancelButton

var bus_master = AudioServer.get_bus_index("Master")
var bus_music = AudioServer.get_bus_index("Music")
var bus_sfx = AudioServer.get_bus_index("SFX")

func _ready():
	# Cố gắng tự động tạo Bus nếu chưa có để tránh lỗi (dù đã setup file .tres)
	if bus_music == -1: AudioServer.add_bus(1); AudioServer.set_bus_name(1, "Music"); bus_music = AudioServer.get_bus_index("Music")
	if bus_sfx == -1: AudioServer.add_bus(2); AudioServer.set_bus_name(2, "SFX"); bus_sfx = AudioServer.get_bus_index("SFX")
	
	if bus_master == -1: bus_master = 0
	
	_load_current_settings()
	
	apply_btn.pressed.connect(_on_apply_pressed)
	cancel_btn.pressed.connect(_on_cancel_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# Toggle menu and pause state
		visible = not visible
		get_tree().paused = visible
		
		# Mỗi lần mở menu lên thì cập nhật lại thanh trượt
		if visible:
			_load_current_settings()

func _load_current_settings():
	# Convert db to percentage (0 to 100) or just use standard range like -24db to 0db mapped to 0-100
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_master)) * 100
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_music)) * 100
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_sfx)) * 100

func _on_apply_pressed():
	_set_bus_volume(bus_master, master_slider.value)
	_set_bus_volume(bus_music, music_slider.value)
	_set_bus_volume(bus_sfx, sfx_slider.value)
	
func _set_bus_volume(bus_index: int, slider_val: float):
	if slider_val <= 0.01:
		AudioServer.set_bus_volume_db(bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(slider_val / 100.0))
	
	# Resume game
	visible = false
	get_tree().paused = false

func _on_cancel_pressed():
	# Revert logic isn't strictly necessary for a simple UI, just close it and discard slider changes
	_load_current_settings() # Reset visually
	
	# Resume game
	visible = false
	get_tree().paused = false
