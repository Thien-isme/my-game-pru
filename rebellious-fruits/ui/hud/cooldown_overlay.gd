@tool
extends Control

## Tỉ lệ cooldown còn lại (1.0 = đầy, 0.0 = hết)
var cooldown_ratio: float = 0.0
## Tỉ lệ active đã trôi qua (dùng khi W đang active)
var active_ratio: float = 0.0
## true = đang trong giai đoạn active (hiện vàng nhạt)
var is_active_phase: bool = false

func _draw():
	var center = size / 2.0
	var radius = min(size.x, size.y) / 2.0
	
	if is_active_phase:
		# Khi đang active: vẽ lớp phủ vàng bán trong - không xám
		draw_circle(center, radius, Color(1.0, 0.9, 0.0, 0.0))
	elif cooldown_ratio > 0:
		# Khi đang cooldown: vẽ hình tròn cung tối để che khuất skill
		var start_angle = -PI / 2.0  # Bắt đầu từ đỉnh
		var end_angle = start_angle + cooldown_ratio * TAU
		
		# Vẽ hình quạt xám tối
		var points = PackedVector2Array()
		points.append(center)
		var steps = 64
		for i in range(steps + 1):
			var t = float(i) / float(steps)
			if t > cooldown_ratio:
				break
			var angle = start_angle + t * TAU
			points.append(center + Vector2(cos(angle), sin(angle)) * radius)
		
		if points.size() > 2:
			draw_polygon(points, PackedColorArray([Color(0.0, 0.0, 0.0, 0.65)]))
