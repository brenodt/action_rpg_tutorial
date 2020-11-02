extends Node2D

func create_grass_effect():
	# This is a SCENE
		var GrassEffect = load("res://Effects/GrassEffect.tscn")
		# This is a Node <- an INSTANCE of a SCENE
		var grassEffect = GrassEffect.instance()
		
		var world = get_tree().current_scene
		world.add_child(grassEffect)
		
		# We're inserted in the context of `Grass`. So, here,
		# we access the `global_position` param of the grass
		# and set it to the instance.global_position
		grassEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	
	# This function adds this node to a queue
	# of nodes that should be destoyed, removed from the game.
	# The node is, then, removed on the next frame.
	queue_free()
