extends Node2D

@onready var digged_gold = $Control/ColorRect/DiggedGold

# Called when the node enters the scene tree for the first time.
func _ready():
	var config = ConfigFile.new()
	
	# Otwórz plik konfiguracyjny
	var err = config.load("user://settings.cfg")
	if err == OK:
		# Pobierz wynik z sekcji "game" i klucza "highscore"
		var gold = config.get_value("game", "total_gold", 0)  # Domyślna wartość to 0, jeśli nie istnieje
		#var gold = config.get_value("game", "total_gold", 0)
		#print( "zloto " + str(gold))
		#print("Załadowano wynik:", highscore)
		digged_gold.text = digged_gold.text + " " + str(gold)
	else:
		digged_gold.text = str(0)



func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
