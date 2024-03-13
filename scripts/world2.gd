extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()

#func _on_world2_transition_point_body_entered(body):

func _on_world_2_exit_point_body_entered(body:Node2D):
	if body.has_method("player"):
		print("exit entered, setting transition_scene to: true")
		global.transition_scene = true # Replace with function body.

# #tihs function was causing issues, setting transition scene to false too early
# func _on_world2_transition_point_body_exited(body):
# 	if body.has_method("player"):
# 		#print("door exited, setting transition_scene to: false")
# 		#global.transition_scene = false
# 		pass
		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world2":
			print("current_scene is: ", global.current_scene)
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.game_first_loadin = false
			#calling this function in global so world2 can communicate with world
			global.finish_changescenes()



