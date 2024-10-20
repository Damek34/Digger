extends Node

var show_digged
var game_mode_number
var selected_pickaxe_id

var is_golden_pickaxe_available
var is_iron_pickaxe_available
var is_diamond_pickaxe_available
var is_ruby_pickaxe_available


const SAVE_FILE = "user://save_game_digger.save"
const SAVE_SETTINGS = "user://save_settings_digger.save"
const SAVE_BEST_SCORE_GAMEMODE = "user://save_best_mode_gamemode_digger.save"
const SAVE_DEEPEST_DEPTH_GAMEMODE = "user://save_deepest_depth_gamemode_digger.save"
const SAVE_SELECTED_PICKAXE = "user://save_selected_pickaxe_digger.save"
const SAVE_AVAILABLE_PICKAXES = "user://save_available_pickaxes_digger.save"


func _ready():
	#Settings
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
	
	
	#Selected Pickaxe
	if FileAccess.file_exists(Globals.SAVE_SELECTED_PICKAXE):
		var file = FileAccess.open(Globals.SAVE_SELECTED_PICKAXE, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var settings = file.get_var()
			file.close()
			
			# Sprawdź, czy uzyskane dane są prawidłowe
			selected_pickaxe_id = settings.get("pickaxe", 0)
			
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
			selected_pickaxe_id = 0
	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		selected_pickaxe_id = 0
	
	
	available_pickaxes()



func available_pickaxes():
	#Available Pickaxes
	if FileAccess.file_exists(Globals.SAVE_AVAILABLE_PICKAXES):
		var file = FileAccess.open(Globals.SAVE_AVAILABLE_PICKAXES, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var pickaxes = file.get_var()
			file.close()
			
			# Sprawdź, czy uzyskane dane są prawidłowe
			is_golden_pickaxe_available = pickaxes.get("golden", false)
			is_iron_pickaxe_available = pickaxes.get("iron", false)
			is_diamond_pickaxe_available = pickaxes.get("diamond", false)
			is_ruby_pickaxe_available = pickaxes.get("ruby", false)
			
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
			selected_pickaxe_id = 0
			is_golden_pickaxe_available = false
			is_iron_pickaxe_available = false
			is_diamond_pickaxe_available = false
			is_ruby_pickaxe_available = false
	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		selected_pickaxe_id = 0
		is_golden_pickaxe_available = false
		is_iron_pickaxe_available = false
		is_diamond_pickaxe_available = false
		is_ruby_pickaxe_available = false
