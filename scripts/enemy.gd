extends CharacterBody2D
#higher number speed = slower
var speed = 40
var active = true
var player_chase = false
var player = null
var health = 100
var player_inattack_zone = false
var can_take_damage = true

func _physics_process(_delta):
	#This runs every frame
	deal_with_damage()
	update_health()
	
	if player_chase:
		position += (player.position - position)/speed
		
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false

#Whatever has this "enemy" method is designated as an enemy
func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.get_node("../player").player_alive == false:
		player_inattack_zone = false
		return
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		
#Enemy Taking Damage Function
func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("enemy health = ", health)
			#enemy death
			if health <= 0:
				global.score += 1
				print("score = ", global.score)
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
