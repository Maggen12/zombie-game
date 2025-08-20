extends Area2D

var speed = 2000

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombies"):
		body.take_damage(1)
		queue_free()
		get_node("/root/GlobalVariables").enemies_killed += 1
 
