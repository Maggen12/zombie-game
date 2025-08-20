extends Area2D

@onready var pickupSound = $pickupSound

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if get_node("/root/GlobalVariables").player_health < 100:
			get_node("/root/GlobalVariables").player_health += 30
			if get_node("/root/GlobalVariables").player_health > 100:
				get_node("/root/GlobalVariables").player_health = 100
			pickupSound.play()
			body.set_health_bar()
			$Sprite2D.hide()
			await pickupSound.finished
			queue_free()
			print(get_node("/root/GlobalVariables").player_health)
		else:
			return
		
			
func _ready():
	destroy_after_seconds(20)

func destroy_after_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	queue_free()
