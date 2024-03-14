extends CharacterBody2D

signal player_died
var enemy_inattack_range = false
var enemy_attack_cooldown = true
#When testing, remember to set health back to 100
var health = 100
var player_alive = true
#ip: In Progress
var attack_ip = false

const speed = 100
var current_dir = "none"

@warning_ignore("unused_parameter")
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x= 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()

func _ready():
	var anim = $AnimatedSprite2D
	global.player = self
	anim.play("front_idle")

#sounds
@onready var sword = $sword
@onready var damage = $damage
@onready var death = $death


func _physics_process(delta):
	#calling functions here bc this is every frame
	current_camera()
	
	if player_alive == true:
		player_movement(delta)
		enemy_attack()
		attack()
		update_health()

	#winning game function
	if global.score >= 5:
		global.win_game()
	
	if health <= 0:
		player_alive = false
		die()

func die():
	var anim = $AnimatedSprite2D
	health = 0
	emit_signal("player_died")
	print("Player has been killed")
	death.play()
	anim.play("death")
	global._on_player_died()
	

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")

#method designating player as player
func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
#Player takes damage function
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		damage.play()
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Player Health: ", health)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true;

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		#play sound for sword
		sword.play()

		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
	
func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
	elif global.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true
	else:
		$world_camera.enabled = true
		$cliffside_camera.enabled = false

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 100:
		health = health + 20
	if health > 100:
		health = 100
	if health <= 0:
		health = 0

