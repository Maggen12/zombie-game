extends Area2D

@onready var explosion = preload("res://explosion.tscn")


func _on_area_entered(body: Node2D) -> void:
	var explo = explosion.instantiate()
	explo.position = $Sprite2D.position
	$explosionTimer.start()
	add_child(explo)
	explo.call_deferred("apply_damage")
	get_parent().get_node("explosion").play()

	

func _on_explosion_timer_timeout() -> void:
	$Sprite2D.queue_free()
	$explosion_effect.emitting = true
	$explosionAfterTimer.start()



func _on_explosion_after_timer_timeout() -> void:
	queue_free()
