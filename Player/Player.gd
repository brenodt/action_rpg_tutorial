extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

var velocity = Vector2.ZERO

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

# $ Notation let's us select nodes from the same scene
# Instantiate using `onready` to ensure child is ready. Similar to
# instantiating in _ready(), just a sintatic sugar
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _process(delta):
	# Similar to a `switch` statement
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state()

func move_state(delta: float):
		# DON'T modify position manually
	# position.x += 10
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Clips the value to a maximum, otherwise diagonals add up
	input_vector = input_vector.normalized()
	
	# multiply by delta makes movement relative to framerate
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state():
	# Reset velocity to avoid "sliding" effect at the end of animation
	velocity = Vector2.ZERO
	animationState.travel("Attack")

# This function is triggered at the end of attack animations to let the
# system know that the animation finished & state can change
func attack_animation_finished():
	state = MOVE
