extends Node

signal game_over

@onready var player
var player_current_attack = false

var current_scene = "world" #world or world2
var transition_scene = false 
var score = 0

var player_exit_world2_posx = 395
var player_exit_world2_posy = 120
var player_start_posx = 20
var player_start_posy = 120

var game_first_loadin = true
var game_state = "idle"

func _ready():
	pass
	# if game_state == "running" or game_state == "over":
	# 	player = get_node("/root/world/player")
	# 	return player.player_died.connect(_on_player_died)

func _on_player_died():
	print("global has recieved death signal")
	print("now emiting: game_over")
	emit_signal("game_over")
	end_game()
	

func end_game():
	game_state = "over"
	get_tree().change_scene_to_file("res://scenes/menu_end.tscn")
	current_scene = "end_screen"
	#go to end game screen
	#save anything worth saving

func win_game():
	game_state = "over"
	get_tree().change_scene_to_file("res://scenes/menu_win.tscn")
	current_scene = "win_screen"
	#go to win game screen
	#save anything worth saving

func finish_changescenes():
	print("finish_changescenes called")
	if transition_scene == true:
		transition_scene = false
		print("transition_scene set to: false")
		if current_scene == "world":
			print("Current scene is world, going to world2")
			current_scene = "world2"
		else:
			print("Current scene is not world, going to world")
			current_scene = "world"
		print("New current_scene var is: ", current_scene)
	else:
		print("error: transition_scene is false for some reason, function not run")
