extends ProgressBar

#var playerHealth : int = get_node("/root/GlobalVariables").player_health

func _ready() -> void:
	set_health_bar()

func set_health_bar():
	$HealthBar.value = get_node("/root/GlobalVariables").player_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
