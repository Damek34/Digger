extends Node2D

@onready var music_slider = $Control/ColorRect/Music/MusicSlider
@onready var sfx_slider = $Control/ColorRect/SFX/SFX_Slider
@onready var check_box_show_blocks = $Control/ColorRect/ShowDiggedBlocks/CheckBox



func _ready():
	var config = ConfigFile.new()
	
	var err = config.load("user://settings.cfg")
	if err == OK:
		var music_volume = config.get_value("game", "music_volume", 1)  
		var sfx_volume = config.get_value("game", "sfx_volume", 1)
		var show_digged = config.get_value("game", "show_digged", true)
		
		
		music_slider.value = music_volume
		sfx_slider.value = sfx_volume
		check_box_show_blocks.set_pressed_no_signal(show_digged)
	else:
		music_slider.value = 100
		sfx_slider.value = 100
	
	
	#sfx_slider.add_theme_stylebox_override("grabber", StyleBoxEmpty)

func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")



func _on_music_slider_drag_ended(value_changed):
	var volume_in_db = log(music_slider.value) * 20
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_in_db)
	
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		print("Nie udało się otworzyć pliku konfiguracyjnego.")
	
	config.set_value("game", "music_volume", music_slider.value)
	config.save("user://settings.cfg")


func _on_sfx_slider_drag_ended(value_changed):
	var volume_in_db = log(sfx_slider.value) * 20
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume_in_db)
	
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		print("Nie udało się otworzyć pliku konfiguracyjnego.")
	
	config.set_value("game", "sfx_volume", sfx_slider.value)
	config.save("user://settings.cfg")


func _on_check_box_toggled(toggled_on):
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		print("Nie udało się otworzyć pliku konfiguracyjnego.")
	config.set_value("game", "show_digged", toggled_on)
	config.save("user://settings.cfg")
	
	Globals.show_digged = toggled_on
