extends Node

@onready var audio_player = AudioStreamPlayer.new()

var playlist = [
	preload("res://Assets/music/background music2.wav"),
	preload("res://Assets/music/background music1.wav"),
	preload("res://Assets/music/background music3.wav"),
]

var current_track_index = 0

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
			
			var music_volume_in_db = log(music_volume) * 20
			var sfx_volume_in_db = log(sfx_volume) * 20
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume_in_db)
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume_in_db)
			
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0)
	
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().create_timer(4.5).timeout
	add_child(audio_player)
	play_next_track()

func play_next_track():
	audio_player.bus = "Music"
	audio_player.stream = playlist[current_track_index]
	audio_player.play()

	current_track_index += 1
	if current_track_index >= playlist.size():
		current_track_index = 0 

	await audio_player.finished

	play_next_track()
