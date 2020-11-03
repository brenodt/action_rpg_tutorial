extends Node

export(int) var max_health = 1
onready var health = max_health setget set_health

signal health_depleted

func set_health(value: int):
	health = value
	if health <= 0:
		emit_signal("health_depleted")
