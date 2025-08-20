extends Node
@onready var enemy = preload("res://enemy.tscn")
var spawned = 0
var max_per_wave = 5
@onready var wave_button = get_parent().get_node("player/WaveButton")
@onready var wave_begun = $WaveBegun
@onready var wave_music = $WaveMusic
@onready var calmBeforeStorm = $"../calmBeforeStorm"
@onready var click = $click


	
func start_wave():
	spawned = 0
	get_node("/root/GlobalVariables").wave_active = true
	$spawntimer.start()
	calmBeforeStorm.stop()


func _on_timer_timeout() -> void:
	if get_node("/root/GlobalVariables").wave_active == true:
		if spawned < max_per_wave:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			
			$"../player/Path2D/PathFollow2D".progress = rng.randi_range(0, 8750)
			
			var ene = enemy.instantiate()
			ene.position = $"../player/Path2D/PathFollow2D".position
			get_parent().get_node("enemyhandler").add_child(ene)
			ene.add_to_group("zombies")
			spawned += 1
			print("spawned:", spawned)
			wave_music.play()
		else:
			$spawntimer.stop()
			print("wave finished spawning")

func _physics_process(delta):
	var enemy_handler = get_parent().get_node("enemyhandler")
	if get_node("/root/GlobalVariables").wave_active and spawned == max_per_wave and enemy_handler.get_child_count() == 0:
		wave_button.visible = true
		get_node("/root/GlobalVariables").wave_active = false
		print("Wave", get_node("/root/GlobalVariables").current_wave, "ready to start")
		max_per_wave += 5
		$spawntimer.set_wait_time(4)
		if get_node("/root/GlobalVariables").current_wave >= 2:
			$spawntimer.set_wait_time(2)
		wave_music.stop()
		calmBeforeStorm.play()
	

func _on_wave_button_pressed() -> void:
	wave_button.visible = false
	start_wave()
	get_node("/root/GlobalVariables").current_wave += 1
	wave_begun.play()
	click.play()
	
