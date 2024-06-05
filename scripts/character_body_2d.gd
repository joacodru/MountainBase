extends CharacterBody2D

@onready var animationPlayer = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0:
			animationPlayer.play("fall")
		else:
			animationPlayer.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	animationPlayer.flip_h = direction < 0 if direction else animationPlayer.flip_h
	
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			animationPlayer.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			animationPlayer.play("idle")

	move_and_slide()
