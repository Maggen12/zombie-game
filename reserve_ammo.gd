extends RichTextLabel

var reserve_ammo_txt = "Reserve ammo: "

func _process(delta: float) -> void:
	var text = str(reserve_ammo_txt, get_node("/root/GlobalVariables").reserve_ammo)
	self.text = (text)
