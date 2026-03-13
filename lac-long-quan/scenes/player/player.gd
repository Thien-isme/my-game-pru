extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const CROUCH_SPEED = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

var is_crouching = false
var is_skill_active = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle skill input if not already in a skill animation
	if not is_skill_active:
		handle_skills()
		handle_movement(delta)
	
	move_and_slide()
	update_animations()

func handle_movement(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle Crouch.
	if Input.is_action_pressed("crouch") and is_on_floor():
		is_crouching = true
	else:
		is_crouching = false

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	var current_speed = CROUCH_SPEED if is_crouching else SPEED
	
	if direction:
		velocity.x = direction * current_speed
		if direction > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

func handle_skills():
	if Input.is_action_just_pressed("skill_q"):
		play_skill("skill_q")
	elif Input.is_action_just_pressed("skill_w"):
		play_skill("skill_w")
	elif Input.is_action_just_pressed("skill_e"):
		play_skill("skill_e")
	elif Input.is_action_just_pressed("skill_r"):
		play_skill("skill_r")

func play_skill(skill_name):
	is_skill_active = true
	animated_sprite.play(skill_name)
	# Logic to reset is_skill_active after animation ends
	# This assumes the animation is set to non-looping or we connect to the signal

func _on_animated_sprite_2d_animation_finished():
	if is_skill_active:
		is_skill_active = false
		# Return to idle or current state
		update_animations()

func update_animations():
	if is_skill_active:
		return

	if not is_on_floor():
		animated_sprite.play("jump")
	elif is_crouching:
		animated_sprite.play("crounch") # Using the folder name spelling
	elif velocity.x != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

func _ready():
	# Connect the signal for animation finished
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
