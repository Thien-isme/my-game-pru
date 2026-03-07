extends CharacterBody2D

var direction: Vector2 = Vector2.RIGHT
@export var speed: float = 300.0
@export var damage: int = 1

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		var collider = collision.get_collider()
		if collider != null and collider.is_in_group("player"):
			collider.take_damage(damage)
		queue_free()
