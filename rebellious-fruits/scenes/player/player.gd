extends CharacterBody2D

const SPEED = 200
const JUMP_FORCE = -550
const GRAVITY = 900

@onready var anim = $AnimatedSprite2D

var is_shooting = false
var is_jump = false

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if direction != 0:
		anim.flip_h = direction < 0

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	# shoot
	if Input.is_action_just_pressed("shoot") and not is_shooting:
		is_shooting = true
		anim.play("shoot")
		await get_tree().create_timer(0.8).timeout
		is_shooting = false

	if Input.is_action_just_pressed("jump") and not is_shooting:
		is_jump = true
		anim.play("jump")
		await get_tree().create_timer(0.3).timeout
		is_shooting = false
		
	# animation
	if not is_shooting:
		if not is_on_floor():
			anim.play("jump")
		elif direction != 0:
			anim.play("run")
		else:
			anim.play("idle")

	move_and_slide()
