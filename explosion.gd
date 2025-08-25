extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_node("/root/GlobalVariables").player_health -= 50
	if body.is_in_group("zombies"):
		body.take_damage(3)


		
