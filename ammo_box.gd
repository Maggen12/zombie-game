extends Area2D

@onready var pickupSound = $pickupSound

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.reserve_ammo < 24:
			body.reserve_ammo += 12
			if body.reserve_ammo > 24:
				body.reserve_ammo = 24
			pickupSound.play()
			$Sprite2D.hide()
			body.ammoChange()
			await pickupSound.finished
			queue_free()
			
func _ready():
	destroy_after_seconds(20)

func destroy_after_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	queue_free()
