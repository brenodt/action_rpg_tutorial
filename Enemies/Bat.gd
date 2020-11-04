extends KinematicBody2D

const DeathEffect = preload("res://Effects/BatDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

export var FRICTION = 200
export var ACCELERATION = 120
export var MAX_SPEED = 50

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite

var state = IDLE

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var player = playerDetectionZone.player
			if !playerDetectionZone.can_see_player():
				state = IDLE
				break
			var direction = (player.global_position - global_position).normalized()
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			sprite.flip_h = velocity.x < 0
	
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * ACCELERATION

func _on_Stats_health_depleted():
	queue_free()
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
