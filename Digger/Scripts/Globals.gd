extends Node

var show_digged


func _ready():
	var config = ConfigFile.new()
	
	var err = config.load("user://settings.cfg")
	if err == OK:
		var show_digged_blocks = config.get_value("game", "show_digged", true)
		show_digged = show_digged_blocks
	else:
		show_digged = true
