extends Node2D
@onready var selecting_background: TextureRect = $Control/ColorRect/SelectingBackground
@onready var info: Label = $Control/ColorRect/SelectingBackground/Info
@onready var record: Label = $Control/ColorRect/SelectingBackground/Record


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_back_from_selecting_pressed() -> void:
	selecting_background.visible = false


func _on_best_score_game_mode_pressed() -> void:
	Globals.game_mode_number = 1
	selecting_background.visible = true
	info.text = "This mode is about achieving the highest possible result in 3 minutes"
	
	if FileAccess.file_exists(Globals.SAVE_BEST_SCORE_GAMEMODE):
		var file = FileAccess.open(Globals.SAVE_BEST_SCORE_GAMEMODE, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var settings = file.get_var()
			file.close()
			
			# Sprawdź, czy uzyskane dane są prawidłowe
			var highscore = settings.get("highscore", 0)
			record.text = "RECORD: " + str(highscore)
			
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		record.text = "RECORD: 0"
	
	


func _on_max_depth_game_mode_pressed() -> void:
	Globals.game_mode_number = 2
	selecting_background.visible = true
	info.text = "This mode is about achieving the deepest depth in 3 minutes"
	
	
	
	if FileAccess.file_exists(Globals.SAVE_DEEPEST_DEPTH_GAMEMODE):
		var file = FileAccess.open(Globals.SAVE_DEEPEST_DEPTH_GAMEMODE, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var settings = file.get_var()
			file.close()
			
			# Sprawdź, czy uzyskane dane są prawidłowe
			var highscore = settings.get("highscore", 0)
			record.text = "RECORD: " + str(highscore)
			
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		record.text = "RECORD: 0"


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
