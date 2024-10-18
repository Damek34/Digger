extends Node

var show_digged
const SAVE_FILE = "user://save_game_digger.save"
const SAVE_SETTINGS = "user://save_settings_digger.save"

func _ready():
	if FileAccess.file_exists(Globals.SAVE_SETTINGS):
		var file = FileAccess.open(Globals.SAVE_SETTINGS, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var settings = file.get_var()
			file.close()
			
			var show_digged_save = settings.get("show_digged", true)
			show_digged = show_digged_save
			
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
	else:
		show_digged = true
