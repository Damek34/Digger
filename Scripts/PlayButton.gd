extends TextureButton

func _ready():
	focus_mode = Control.FOCUS_NONE
	
func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
