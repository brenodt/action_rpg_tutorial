extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

var velocity = Vector2.ZERO

# $ Notation let's us select nodes from the same scene
# Instantiate using `onready` to ensure child is ready. Similar to
# instantiating in _ready(), just a sintatic sugar
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	# DON'T modify position manually
	# position.x += 10
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Clips the value to a maximum, otherwise diagonals add up
	input_vector = input_vector.normalized()
	
	# multiply by delta makes movement relative to framerate
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("IdleDown")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
