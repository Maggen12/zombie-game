extends RichTextLabel

var current_ammo_txt = "Current ammo: "


func _process(delta: float) -> void:
	var text = str(current_ammo_txt, get_node("/root/GlobalVariables").current_ammo)
	self.text = (text)
