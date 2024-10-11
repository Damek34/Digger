extends TextureRect

@onready var back_to_game_button = $BackToGame
@onready var ok_button = $OK


func _ready():
	back_to_game_button.focus_mode = Control.FOCUS_NONE
	ok_button.focus_mode = Control.FOCUS_NONE
	process_mode = Node.PROCESS_MODE_ALWAYS




func _on_back_to_game_pressed():
	get_tree().paused = false
	visible = false



func _on_ok_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
