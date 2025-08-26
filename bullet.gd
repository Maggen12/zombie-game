extends Area2D

var speed = 4000
var spread_angle: float = randf_range(-2.5, 2.5)
var spread_radians = deg_to_rad(spread_angle)

func _physics_process(delta: float) -> void:
	position += transform.x.rotated(spread_radians) * speed * delta
	 
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombies"):
		body.take_damage(1)
		queue_free()
		get_node("/root/GlobalVariables").enemies_killed += 1
 
