extends Control

@onready var music_slider: HSlider = $CenterContainer/TextureRect/VBoxSettings/MusicHBox/MusicSlider
@onready var sfx_slider: HSlider = $CenterContainer/TextureRect/VBoxSettings/SFXHBox/SFXSlider
@onready var master_slider: HSlider = $CenterContainer/TextureRect/VBoxSettings/MasterHBox/MasterSlider

@onready var apply_btn: TextureButton = $CenterContainer/TextureRect/HBoxButtons/ApplyButton
@onready var cancel_btn: TextureButton = $CenterContainer/TextureRect/HBoxButtons/CancelButton

var bus_master = AudioServer.get_bus_index("Master")
var bus_music = AudioServer.get_bus_index("Music")
var bus_sfx = AudioServer.get_bus_index("SFX")

func _ready():
	# If bus is not found (might be -1), we use Master as fallback for all to prevent crash, or check it.
	if bus_master == -1: bus_master = 0
	if bus_music == -1: bus_music = 0
	if bus_sfx == -1: bus_sfx = 0
	
	_load_current_settings()
	
	apply_btn.pressed.connect(_on_apply_pressed)
	cancel_btn.pressed.connect(_on_cancel_pressed)

func _load_current_settings():
	# Convert db to percentage (0 to 100) or just use standard range like -24db to 0db mapped to 0-100
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_master)) * 100
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_music)) * 100
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_sfx)) * 100

func _on_apply_pressed():
	AudioServer.set_bus_volume_db(bus_master, linear_to_db(master_slider.value / 100.0))
	AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_slider.value / 100.0))
	AudioServer.set_bus_volume_db(bus_sfx, linear_to_db(sfx_slider.value / 100.0))
	visible = false

func _on_cancel_pressed():
	# Revert logic isn't strictly necessary for a simple UI, just close it and discard slider changes
	_load_current_settings() # Reset visually
	visible = false
