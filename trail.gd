extends Line2D

@export var length := 10
var trail_points := []

func _physics_process(delta):
	# Store the bullet's global position
	var bullet_global_pos = get_parent().global_position
	trail_points.insert(0, bullet_global_pos)  # Add new point at the start

	# Keep only the last `length` points
	if trail_points.size() > length:
		trail_points.pop_back()

	# Update Line2D points
	clear_points()
	for p in trail_points:
		add_point(p)
