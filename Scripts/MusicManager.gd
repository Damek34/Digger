extends Node

@onready var audio_player = AudioStreamPlayer.new()

var playlist = [
	preload("res://Assets/music/background music2.wav"),
	preload("res://Assets/music/background music1.wav"),
	preload("res://Assets/music/background music3.wav"),
]

var current_track_index = 0

func _ready():
	var config = ConfigFile.new()
	
	var err = config.load("user://settings.cfg")
	if err == OK:
		var music_volume = config.get_value("game", "music_volume", 1)  
		var sfx_volume = config.get_value("game", "sfx_volume", 1)
		
		var music_volume_in_db = log(music_volume) * 20
		var sfx_volume_in_db = log(sfx_volume) * 20
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume_in_db)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume_in_db)
	else:
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
