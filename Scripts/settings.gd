extends Node2D

@onready var music_slider = $Control/ColorRect/Music/MusicSlider
@onready var sfx_slider = $Control/ColorRect/SFX/SFX_Slider
@onready var check_box_show_blocks = $Control/ColorRect/ShowDiggedBlocks/CheckBox



func _ready():
	if FileAccess.file_exists(Globals.SAVE_SETTINGS):
		var file = FileAccess.open(Globals.SAVE_SETTINGS, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var settings = file.get_var()
			file.close()
			
			# Sprawdź, czy uzyskane dane są prawidłowe
			var music_volume = settings.get("music_volume", 1)
			var sfx_volume = settings.get("sfx_volume", 1)
			var show_digged = settings.get("show_digged", true)
			
			# Zapisz dane, korzystając z uzyskanych wartości
			music_slider.value = music_volume
			sfx_slider.value = sfx_volume
			check_box_show_blocks.set_pressed_no_signal(show_digged)
			
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		music_slider.value = 100
		sfx_slider.value = 100
		check_box_show_blocks.set_pressed_no_signal(true)
	
	
	#sfx_slider.add_theme_stylebox_override("grabber", StyleBoxEmpty)

func _process(delta):
	pass


func _on_button_pressed():
	var settings = {}

	settings["music_volume"] = music_slider.value
	settings["sfx_volume"] = sfx_slider.value
	settings["show_digged"] = Globals.show_digged

	
	# Zapisz dane do pliku
	var file = FileAccess.open(Globals.SAVE_SETTINGS, FileAccess.WRITE)
	
	# Sprawdzenie, czy plik został otwarty
	if file.is_open():
		file.store_var(settings)
		file.close()
		print("Dane zapisane pomyślnie.")
	else:
		print("Nie udało się otworzyć pliku do zapisu.")
	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")



func _on_music_slider_drag_ended(value_changed):
	var volume_in_db = log(music_slider.value) * 20
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_in_db)


func _on_sfx_slider_drag_ended(value_changed):
	var volume_in_db = log(sfx_slider.value) * 20
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume_in_db)

func _on_check_box_toggled(toggled_on):

	Globals.show_digged = toggled_on
