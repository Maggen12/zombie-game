extends Node

@onready var calmBeforeStorm = $calmBeforeStorm
var height: int = 1080
var width: int = 1920
@onready var ammoBox = preload("res://ammo_box.tscn")
@onready var enemy = preload("res://enemy.tscn")
@onready var spawnTimer = $spawntimer
@onready var barrel = preload("res://exploding_barrel.tscn")
var spawned = 0
var max_per_wave = 5
@onready var wave_button = get_node("WaveButton")
@onready var wave_begun = $WaveBegun
@onready var wave_music = $WaveMusic
@onready var click = $click
@onready var medKit = preload("res://medkit.tscn")
@onready var medKitTimer = $medKitTimer
@onready var AmmoTimer = $AmmoTimer



func _ready() -> void:
	calmBeforeStorm.play()


func _on_ammo_timer_timeout() -> void:
	if get_node("/root/GlobalVariables").wave_active == true:
		var nheight = randi_range(0, height)
		var nwidth = randi_range(0, width)
		var ammoBoxScene = ammoBox.instantiate()
		ammoBoxScene.position = Vector2(nwidth, nheight)
		add_child(ammoBoxScene)
	
func start_wave():
	spawned = 0
	get_node("/root/GlobalVariables").wave_active = true
	spawnTimer.start()
	calmBeforeStorm.stop()
	medKitTimer.start()
	AmmoTimer.start()
	$explosiveBarrelTimer.start()
	


func _on_timer_timeout() -> void:
	if get_node("/root/GlobalVariables").wave_active == true:
		if spawned < max_per_wave:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			$player/Path2D/PathFollow2D.progress = rng.randi_range(0, 8750)
			var ene = enemy.instantiate()
			ene.position = $player/Path2D/PathFollow2D.position
			get_node("enemyhandler").add_child(ene)
			ene.add_to_group("zombies")
			spawned += 1
			print("spawned:", spawned)
			wave_music.play()
		else:
			$spawntimer.stop()
			print("wave finished spawning")

func _physics_process(delta):
	var enemy_handler = get_node("enemyhandler")
	if get_node("/root/GlobalVariables").wave_active and spawned == max_per_wave and enemy_handler.get_child_count() == 0:
		wave_button.visible = true
		get_node("/root/GlobalVariables").wave_active = false
		max_per_wave += 10
		$spawntimer.set_wait_time(3)
		if get_node("/root/GlobalVariables").current_wave >= 2:
			$spawntimer.set_wait_time(2)
			max_per_wave += 20
		elif get_node("/root/GlobalVariables").current_wave >= 5:
			max_per_wave += 20
			$spawntimer.set_wait_time(2)
		wave_music.stop()
		calmBeforeStorm.play()
	

func _on_wave_button_pressed() -> void:
	wave_button.visible = false
	start_wave()
	get_node("/root/GlobalVariables").current_wave += 1
	wave_begun.play()
	click.play()
	$explosiveBarrelTimer.start()

func _on_med_kit_timer_timeout() -> void:
	if get_node("/root/GlobalVariables").wave_active == true:
		var nheight = randi_range(0, height)
		var nwidth = randi_range(0, width)
		var medKitScene = medKit.instantiate()
		medKitScene.position = Vector2(nwidth, nheight)
		add_child(medKitScene)
	


func _on_explosive_barrel_timer_timeout() -> void:
	if get_node("/root/GlobalVariables").wave_active == true:
		var nheight = randi_range(0, height)
		var nwidth = randi_range(0, width)
		var bar = barrel.instantiate()
		bar.position = Vector2(nwidth, nheight)
		add_child(bar)
		$explodeTheTimer.start()



func _on_explode_the_timer_timeout() -> void:
	if get_node("explodingBarrel"):
		get_node("explodingBarrel").queue_free()
	else:
		return
