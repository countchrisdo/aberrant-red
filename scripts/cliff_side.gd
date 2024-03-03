extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scenes()


func _on_cliffside_exitpoint_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true;


func _on_cliffside_exitpoint_body_exited(body):
	pass # Replace with function body.

func change_scenes():
	if global.transition_scene == true:
		if global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.finish_changescenes()
