extends CharacterBody2D
const SPEED = 400.0
var Bullet = preload("res://bullet.tscn")
@onready var FireDelayTimer = $FireDelay
@export var fire_delay : float = 0.1

var max_ammo := 8 
var current_ammo := max_ammo
var reserve_ammo := 24

var reload_time := 1.2

@onready var reload_timer := $reloadTimer

signal ammo_changed(current: int, reserve: int)

@onready var GunShot = $GunShot
@onready var reload_gun = $reload
@onready var animated = $AnimationPlayer

var is_shooting = false

func _on_reload_timer_timeout() -> void:
	refill_ammo()

func _ready() -> void:
	refill_ammo()
	add_to_group("player")
	set_health_bar()

func movement(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
	if Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
	if Input.is_action_pressed("move_up"):
		velocity.y = -SPEED
	if Input.is_action_pressed("move_down"):
		velocity.y = SPEED
		
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized()*SPEED
		move_and_slide()
		if is_shooting:
			return
		else:
			set_state("run")
		if velocity.x < 0:
			$runSprite.flip_h = true
		elif velocity.x > 0:
			$runSprite.flip_h = false
	else:
		if is_shooting:
			return
		else:
			set_state("idle")
			if get_global_mouse_position().x < global_position.x:
				$idleSprite.flip_h = true
			else:
				$idleSprite.flip_h = false
	

	

func _physics_process(delta: float) -> void:
	$HealthBar.value = get_node("/root/GlobalVariables").player_health
	if get_node("/root/GlobalVariables").player_health <= 0:
		call_deferred("die")
	else:
		movement(delta)
		$gun.look_at(get_global_mouse_position())
		if not reload_timer.is_stopped():
			return
		if Input.is_action_just_pressed("esc") and FireDelayTimer.is_stopped():
			if current_ammo > 0:
				shoot()
			else:
				reload()
		elif Input.is_action_just_pressed("reload") and current_ammo < max_ammo:
			reload()
	set_health_bar()
	
			
func shoot():
	current_ammo -= 1
	FireDelayTimer.start(fire_delay)
	var bul = Bullet.instantiate() 
	bul.position = $gun/Marker2D.global_position
	bul.transform = $gun/Marker2D.global_transform
	get_parent().add_child(bul)
	ammoChange()
	GunShot.play()
	is_shooting = true
	set_state("shoot")
	$is_shooting.start()
	if get_global_mouse_position().x < global_position.x:
		$fireSprite.flip_h = true
	else:
		$fireSprite.flip_h = false

		
func _on_is_shooting_timeout() -> void:
	is_shooting = false


func ammoChange():
	emit_signal("ammo_changed", current_ammo, reserve_ammo)
	
func reload():
	if reserve_ammo <= 0:
		return 
	reload_timer.start(reload_time)
	reload_gun.play()

func refill_ammo():
	var ammo_missing := max_ammo - current_ammo
	if reserve_ammo >= ammo_missing:
		reserve_ammo = reserve_ammo - ammo_missing
		current_ammo = max_ammo
	else:
		current_ammo += reserve_ammo
		reserve_ammo = 0 
	emit_signal("ammo_changed", current_ammo, reserve_ammo)
	
func take_damage(amount):
	get_node("/root/GlobalVariables").player_health -= amount
	if get_node("/root/GlobalVariables").player_health <= 0:
		die()

func die():
	get_tree().change_scene_to_file("res://game_over.tscn")

func set_health_bar():
	$HealthBar.value = get_node("/root/GlobalVariables").player_health
	
func set_state(state):
	$idleSprite.visible = false
	$runSprite.visible = false
	$fireSprite.visible = false
	
	if state == "idle":
		$idleSprite.visible = true
		$AnimationPlayer.play("idle")
	
	if state == "run":
		$runSprite.visible = true
		$AnimationPlayer.play("running")
	
	if state == "shoot":
		$fireSprite.visible = true
		$AnimationPlayer.play("firing")

	
	
