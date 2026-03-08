extends Node

## Quản lý nhạc nền (BGM) cho từng cảnh/màn chơi.
## Kéo thả file nhạc vào đây trong Inspector.
## Đặt node này vào TRONG scene của mỗi Level.

@export_category("Background Music")
## Nhạc nền sẽ phát khi Level này được tải
@export var bgm_track: AudioStream  # Kéo file .ogg / .mp3 vào đây

## Âm lượng phát ra, 0.0 = bình thường, -6.0 = nhỏ hơn một nửa
@export_range(-80.0, 6.0, 0.1) var volume_db: float = 0.0

## Tự động phát nhạc khi vào Level (nếu tắt thì gọi play() thủ công)
@export var autoplay: bool = true

func _ready() -> void:
	if autoplay and bgm_track:
		AudioManager.load_music_stream("_level_bgm_", bgm_track)
		AudioManager.play_music("_level_bgm_")

func play() -> void:
	if bgm_track:
		AudioManager.load_music_stream("_level_bgm_", bgm_track)
		AudioManager.play_music("_level_bgm_")

func stop() -> void:
	AudioManager.stop_music()
