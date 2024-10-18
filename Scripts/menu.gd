extends Node2D

@onready var my_highcore = $Control/ColorRect/MyHighcore
@onready var play: TextureButton = $Control/ColorRect/Play

func _ready():
	if FileAccess.file_exists(Globals.SAVE_FILE):
		var file = FileAccess.open(Globals.SAVE_FILE, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var game_data = file.get_var()
			file.close()
			
			# Sprawdź, czy uzyskane dane są prawidłowe
			var highscore = game_data.get("highscore", 0)
			
			# Zapisz dane, korzystając z uzyskanych wartości
			my_highcore.text = str(highscore)
			
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		my_highcore.text = str(0)
	
	
	


func _on_settings_pressed():
		get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_stats_pressed():
	get_tree().change_scene_to_file("res://Scenes/stats.tscn")
