extends KinematicBody2D

export var FRICTION = 200
export var ACCELERATION = 120

onready var stats = $Stats

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	var knockback_vector = area.knockback_vector
	knockback = knockback_vector * ACCELERATION


func _on_Stats_health_depleted():
	queue_free()
