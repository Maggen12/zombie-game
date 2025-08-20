extends Control
@onready var TitleScreenMusic = $TitleScreenMusic
@onready var click = $click
@onready var Delay = $Delay

func _on_start_button_pressed() -> void:
	click.play()
	Delay.start()


func _on_quit_pressed() -> void:
	get_tree().quit()

func _ready():
	TitleScreenMusic.play()


func _on_delay_timeout() -> void:
	get_tree().change_scene_to_file("res://mainscene.tscn")
	
