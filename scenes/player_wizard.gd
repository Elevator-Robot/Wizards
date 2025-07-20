extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FLOAT_DURATION = 5.0

@onready var animated_sprite = $AnimatedSprite2D

var double_jump_used := false
var in_air_float := false
var float_timer := 0.0

func _physics_process(delta: float) -> void:
	# Gravity logic
	if not is_on_floor() and not in_air_float:
		velocity += get_gravity() * delta

	# Jump logic
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			double_jump_used = false  # Reset when grounded
		elif not double_jump_used:
			velocity.y = JUMP_VELOCITY
			double_jump_used = true
			in_air_float = true
			float_timer = 0.0

	# Float timer handling
	if in_air_float:
		velocity.y = 0  # Suspend vertical movement
		float_timer += delta
		if float_timer >= FLOAT_DURATION:
			in_air_float = false  # Resume gravity

	# Get the input direction
	var direction := Input.get_axis("move_left", "move_right")

	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true		

	# Play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("dash")
	else:
		animated_sprite.play("jump")

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
