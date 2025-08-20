extends RichTextLabel



var default_text = "Score: "

func _process(delta: float) -> void:
	text = "[font_size=36][font=gunplay rg.otf]Score: " + str(get_node("/root/GlobalVariables").score)

	
