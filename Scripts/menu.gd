extends Node2D

@onready var my_highcore = $Control/ColorRect/MyHighcore

# Called when the node enters the scene tree for the first time.
func _ready():
	var config = ConfigFile.new()
	
	# Otwórz plik konfiguracyjny
	var err = config.load("user://settings.cfg")
	if err == OK:
		# Pobierz wynik z sekcji "game" i klucza "highscore"
		var highscore = config.get_value("game", "highscore", 0)  # Domyślna wartość to 0, jeśli nie istnieje
		#var gold = config.get_value("game", "total_gold", 0)
		#print( "zloto " + str(gold))
		#print("Załadowano wynik:", highscore)
		my_highcore.text = str(highscore)
		return highscore
	else:
		my_highcore.text = str(0)


func _on_settings_pressed():
		get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_stats_pressed():
	get_tree().change_scene_to_file("res://Scenes/stats.tscn")
