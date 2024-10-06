extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	focus_mode = Control.FOCUS_NONE
	process_mode = Node.PROCESS_MODE_ALWAYS



func _on_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	#Engine.time_scale = 1.0
