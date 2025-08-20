extends RichTextLabel

var default_text = "Current wave: "

func _process(delta: float) -> void:
	text = "[font_size=36][font=gunplay rg.otf]Current wave: " + str(get_node("/root/GlobalVariables").current_wave)
