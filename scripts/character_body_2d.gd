extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@onready var AnimTree = $AnimationTree

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var direction : float = 0.0

var is_Attacking = false

func _is_attacking():
	return animatedSprite.animation == "attack" and animatedSprite.is_playing()

func _process(_delta: float) -> void:
	_handle_animations()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not _is_attacking():
		# Handle jump.
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		direction = Input.get_axis("ui_left", "ui_right")
		
		if Input.is_action_just_pressed("key_Z") and is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		elif direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _handle_animations():
	animatedSprite.flip_h = direction < 0 if direction else animatedSprite.flip_h
	if is_on_floor():
		AnimTree["parameters/conditions/is_on_floor"] = true
		AnimTree["parameters/conditions/is_jump"] = false
		AnimTree["parameters/conditions/is_fall"] = false
		if Input.is_action_just_pressed("key_Z"):
			AnimTree["parameters/conditions/is_attack"] = true
		elif direction:
			AnimTree["parameters/conditions/is_attack"] = false
			AnimTree["parameters/conditions/is_moving"] = true
			AnimTree["parameters/conditions/idle"] = false
		elif not direction:
			AnimTree["parameters/conditions/is_attack"] = false
			AnimTree["parameters/conditions/idle"] = true
			AnimTree["parameters/conditions/is_moving"] = false
	else:
		AnimTree["parameters/conditions/is_on_floor"] = false
		if velocity.y < 0:
			AnimTree["parameters/conditions/is_jump"] = true
			AnimTree["parameters/conditions/is_fall"] = false
		elif velocity.y > 0:
			AnimTree["parameters/conditions/is_jump"] = false
			AnimTree["parameters/conditions/is_fall"] = true
