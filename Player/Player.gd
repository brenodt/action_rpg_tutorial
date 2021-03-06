extends KinematicBody2D

export var MAX_SPEED = 80
export var ACCELERATION = 500
export var FRICTION = 500
export var ROLL_SPEED = 125

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

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
onready var swordHitbox = $HitboxPivot/SwordHitBox

func _ready():
	animationTree.active = true
	
	swordHitbox.knockback_vector = roll_vector

func _process(delta):
	# Similar to a `switch` statement
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
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
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	move()

func attack_state():
	# Reset velocity to avoid "sliding" effect at the end of animation
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	move()
	animationState.travel("Roll")

# This function is triggered at the end of attack animations to let the
# system know that the animation finished & state can change
func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE

func move():
	velocity = move_and_slide(velocity)
	
