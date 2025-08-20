extends RichTextLabel

@onready var player = $"../../.."

func _ready():
	text = str("[font_size=20][font=gunplay rg.otf]8 / 24")
	player.ammo_changed.connect(_on_player_ammo_changed)

func _on_player_ammo_changed(current: int, reserve: int):
	text = "[font_size=20][font=gunplay rg.otf]" + str(current) + " / " + str(reserve) 

	
