extends RichTextLabel



var default_text = "Money: "

func _process(delta: float) -> void:
	text = "[font_size=36][font=gunplay rg.otf]Money: " + str(get_node("/root/GlobalVariables").money)

	
