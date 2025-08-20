extends CharacterBody2D
@export var speed = 100
var player_position
var target_position
var health : int = 3
@onready var player = get_tree().get_root().get_node("main/player")
@onready var damage_timer = $DamageTimer
var player_in_range = null
@onready var zombieEating = $zombieEating
var hurt = false
var attacking = false
var walking = false
var dead = false

func _ready() -> void:
	set_health_bar()

func _physics_process(delta):
	if dead:
		damage_timer.stop()
		$zombieEating.stop()
		attacking = false
	else:
		player_position = player.position
		target_position = (player.position - position).normalized()
	
		if position.distance_to(player_position) > 3:
			velocity = target_position * speed
			move_and_slide()
			if hurt:
				return
			if attacking:
				return
			else:
				set_state("walk")
				if target_position.x < 0:
					$walking.flip_h = true
				elif target_position.x > 0:
					$walking.flip_h = false
			
		

func take_damage(amount):
	if dead:
		return
	else:
		health -= amount
		set_health_bar()
		set_state("hurt")
		hurt = true
		$hurtTimer.start()
		if player.position.x < global_position.x:
			$hurt.flip_h = true
		else:
			$hurt.flip_h = false
		if health <= 0:
			$bababooey.start()
			
func _bababooey() -> void:
	get_node("/root/GlobalVariables").score += 1
	set_state("dead")
	$deadTimer.start()
	dead = true
	$CollisionShape2D.queue_free()
	if target_position.x < 0:
		$dead.flip_h = true
	elif target_position.x > 0:
		$dead.flip_h = false

func set_health_bar():
	$HealthBar.value = health

func _on_area_2d_body_entered(body: Node2D) -> void:
	if dead:
		return
	else:
		if body.is_in_group("player"):
			player_in_range = body
			damage_timer.start()
			zombieEating.play()
			set_state("attacking")
			attacking = true
			if player.position.x < global_position.x:
				$attacking.flip_h = true
			else:
				$attacking.flip_h = false
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null
		damage_timer.stop()  
		zombieEating.stop()
		attacking = false
		
		
func deal_damage():
	if player_in_range:
		player_in_range.take_damage(10)

func _on_damage_timer_timeout() -> void:
	deal_damage()

func set_state(state):
	$hurt.visible = false
	$walking.visible = false
	$attacking.visible = false
	$dead.visible = false
	
	if state == "hurt":
		$hurt.visible = true
		$AnimationPlayer.play("hurt")
	if state == "walk":
		$walking.visible = true
		$AnimationPlayer.play("walk")
	if state == "attacking":
		$attacking.visible = true
		$AnimationPlayer.play("attacking")
	if state == "dead":
		$dead.visible = true
		$AnimationPlayer.play("die")
	
	
func _on_hurt_timer_timeout() -> void:
	hurt = false

func _on_dead_timer_timeout() -> void:
	print("does this happen")
	$afterDeadTimer.start()

func _on_after_dead_timer_timeout() -> void:
	queue_free()
