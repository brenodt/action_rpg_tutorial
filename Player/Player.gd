extends KinematicBody2D

const MAX_SPEED = 200
const ACCELERATION = 50
const FRICTION = 25

var velocity = Vector2.ZERO

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
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_collide(velocity)
