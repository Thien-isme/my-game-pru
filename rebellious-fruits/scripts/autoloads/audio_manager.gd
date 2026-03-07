extends Node

# Dictionary lưu trữ danh sách các file âm thanh đã được preload vào bộ nhớ
var sound_effects: Dictionary = {}
var music_tracks: Dictionary = {}

# Node dùng để phát BGM (Nhạc nền) - Chỉ cần 1 cái vì nhạc nền chỉ phát 1 bài tại 1 thời điểm
var music_player: AudioStreamPlayer

# Pool các Nodes dùng để phát SFX (Tiếng động) - Cần nhiều Pool để có thể phát chồng nhiều tiếng lên nhau (ví dụ: 10 viên đạn bắn cùng lúc)
var sfx_pool: Array[AudioStreamPlayer] = []
var max_sfx_players: int = 15 # Số lượng âm thanh hiệu ứng tối đa phát CÙNG LÚC

func _ready() -> void:
	# Cài đặt Music Player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Cài đặt SFX Pool
	for i in range(max_sfx_players):
		var sfx_player = AudioStreamPlayer.new()
		sfx_pool.append(sfx_player)
		add_child(sfx_player)
		
	# Mặc định, Godot đưa tất cả vào bus "Master".
	# Sau này bạn có thể tải thêm 2 bus "Music" và "SFX" trong tab Audio phía đáy màn hình,
	# và chỉnh thuộc tính `.bus` của các loa này về đúng bus tương ứng.
	
	# Ví dụ cách load âm thanh mồi (Sau này bạn có audio thì thay đường dẫn vào đây)
	# load_sfx("shoot", "res://assets/audio/sfx/shoot_sound.mp3")
	# load_music("level_1", "res://assets/audio/bgm/level1_theme.ogg")

# --- HÀM TẢI ÂM THANH (PRELOAD) ---
# Dùng các hàm này ở màn hình loading hoặc menu chính để máy tính tải sẵn file nhạc vào RAM,
# Tránh việc đang chơi game thì bị giật lag vì máy phải dừng lại đọc file ổ cứng.
func load_sfx(sound_name: String, file_path: String) -> void:
	if ResourceLoader.exists(file_path):
		sound_effects[sound_name] = load(file_path)
	else:
		push_error("AudioManager: Không tìm thấy file âm thanh '%s' tại đường dẫn '%s'" % [sound_name, file_path])

func load_music(track_name: String, file_path: String) -> void:
	if ResourceLoader.exists(file_path):
		music_tracks[track_name] = load(file_path)
	else:
		push_error("AudioManager: Không tìm thấy file nhạc nền '%s' tại đường dẫn '%s'" % [track_name, file_path])

# --- HÀM PHÁT HIỆU ỨNG ÂM THANH (SFX) ---
# Ví dụ: Măng cụt chết, gọi -> AudioManager.play_sfx("mangosteen_die")
func play_sfx(sound_name: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if not sound_effects.has(sound_name):
		push_warning("AudioManager: Chưa load âm thanh mang tên '%s'. Hãy gọi load_sfx trước." % sound_name)
		return
		
	# Tìm 1 cái loa SFX đang rảnh trong Pool để giao việc phát
	var player_found = false
	for player in sfx_pool:
		if not player.playing:
			player.stream = sound_effects[sound_name]
			player.volume_db = volume_db
			player.pitch_scale = pitch_scale
			player.play()
			player_found = true
			break
			
	if not player_found:
		push_warning("AudioManager: Đã tới giới hạn %d SFX cùng lúc! m thanh '%s' bị bỏ qua." % [max_sfx_players, sound_name])

# --- HÀM PHÁT NHẠC NỀN (BGM) ---
# Ví dụ: Vô Level 1, gọi -> AudioManager.play_music("level_1")
func play_music(track_name: String, fade_in_time: float = 1.0) -> void:
	if not music_tracks.has(track_name):
		push_warning("AudioManager: Chưa load bản nhạc mang tên '%s'. Hãy gọi load_music trước." % track_name)
		return
		
	# Nếu bài nhạc này ĐANG phát roi thì thôi, không bật lại từ đầu
	if music_player.stream == music_tracks[track_name] and music_player.playing:
		return
		
	music_player.stream = music_tracks[track_name]
	music_player.volume_db = -80.0 if fade_in_time > 0 else 0.0 # Bắt đầu từ mức âm lượng 0 nếu có fade
	music_player.play()
	
	if fade_in_time > 0:
		# Tạo hiệu ứng Fade-in (nhỏ dần to dần) nghe cho xịn
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", 0.0, fade_in_time)

func stop_music(fade_out_time: float = 1.0) -> void:
	if not music_player.playing:
		return
		
	if fade_out_time > 0:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, fade_out_time)
		tween.tween_callback(music_player.stop)
	else:
		music_player.stop()
