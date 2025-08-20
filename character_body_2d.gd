extends CharacterBody2D
@export var speed = 100
var player_position
var target_position
@onready var player = get_parent().get_parent().get_node("player")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	player_position = player.position
	target_position = (player.position - position).normalized()
	
	if position.distance_to(player_position) < 3:
		velocity = target_position * speed
		move_and_slide()
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
