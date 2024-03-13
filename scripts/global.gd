extends Node

var player_current_attack = false

var current_scene = "world" #world cliff_side
var transition_scene = false

var player_exit_cliffside_posx = 200
var player_exit_cliffside_posy = 32
var player_start_posx = 232
var player_start_posy = 100

var game_first_loadin = true
var game_state

func _ready():
	game_state = "idle"
	
	
func game_started():
	game_state = "running"
	#run code or call functions important to the games initial operation

func end_game():
	game_state = "over"
	#go to end game screen
	#save anything worth saving

func finish_changescenes():
	print("finish_changescenes called")
	if transition_scene == true:
		transition_scene = false
		print("transition_scene set to: false")
		if current_scene == "world":
			print("Current scene is world, going to cliffside")
			current_scene = "cliff_side"
		else:
			print("Current scene is not world, going to world")
			current_scene = "world"
		print("New current_scene var is: ", current_scene)
	else:
		print("error: transition_scene is false for some reason, function not run")
