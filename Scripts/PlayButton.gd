extends TextureButton

func _ready():
	focus_mode = Control.FOCUS_NONE
	
func _on_pressed():
	Globals.game_mode_number = 0
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
