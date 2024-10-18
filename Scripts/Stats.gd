extends Node2D

@onready var digged_gold = $Control/ColorRect/DiggedGold
@onready var digged_diamonds = $Control/ColorRect/DiggedDiamonds
@onready var highscore_label = $Control/ColorRect/Highscore
@onready var deepest_height = $Control/ColorRect/DeepestHeight
@onready var digged_rubies: Label = $Control/ColorRect/DiggedRubies

func _ready():
	if FileAccess.file_exists(Globals.SAVE_FILE):
		var file = FileAccess.open(Globals.SAVE_FILE, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var game_data = file.get_var()
			file.close()
			
			# Sprawdź, czy uzyskane dane są prawidłowe
			var highscore = game_data.get("highscore", 0)
			var max_depth = game_data.get("max_depth", 0)
			var total_gold = game_data.get("total_gold", 0)
			var total_diamonds = game_data.get("total_diamonds", 0)
			var total_rubies = game_data.get("total_rubies", 0)
			
			highscore_label.text = highscore_label.text + " " + str(highscore)
			deepest_height.text = deepest_height.text + " " + str(max_depth)
			digged_gold.text = digged_gold.text + " " + str(total_gold)
			digged_diamonds.text = digged_diamonds.text + " " + str(total_diamonds)
			digged_rubies.text = digged_rubies.text + " " + str(total_rubies)
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
			digged_gold.text = digged_gold.text + " " + str(0)
			digged_diamonds.text = digged_diamonds.text + " " + str(0)
			highscore_label.text = highscore_label.text + " " + str(0)
			deepest_height.text = deepest_height.text + " " + str(0)
			digged_rubies.text = digged_rubies.text + " " + str(0)
	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		digged_gold.text = digged_gold.text + " " + str(0)
		digged_diamonds.text = digged_diamonds.text + " " + str(0)
		highscore_label.text = highscore_label.text + " " + str(0)
		deepest_height.text = deepest_height.text + " " + str(0)
		digged_rubies.text = digged_rubies.text + " " + str(0)
	
	
	
	
	
	
	
	
	
	
	
	


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
