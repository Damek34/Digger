extends Node2D

@onready var digged_gold = $Control/ColorRect/DiggedGold
@onready var digged_diamonds = $Control/ColorRect/DiggedDiamonds
@onready var highscore_label = $Control/ColorRect/Highscore
@onready var deepest_height = $Control/ColorRect/DeepestHeight

func _ready():
	var config = ConfigFile.new()
	
	var err = config.load("user://settings.cfg")
	if err == OK:
		var highscore = config.get_value("game", "highscore", 0)
		var gold = config.get_value("game", "total_gold", 0)
		var diamonds = config.get_value("game", "total_diamonds", 0)
		var max_depth = config.get_value("game", "max_depth", 0)
		
		highscore_label.text = highscore_label.text + " " + str(highscore)
		deepest_height.text = deepest_height.text + " " + str(max_depth)
		digged_gold.text = digged_gold.text + " " + str(gold)
		digged_diamonds.text = digged_diamonds.text + " " + str(diamonds)
	else:
		digged_gold.text = digged_gold.text + " " + str(0)
		digged_diamonds.text = digged_diamonds.text + " " + str(0)
		highscore_label.text = highscore_label.text + " " + str(0)
		deepest_height.text = deepest_height.text + " " + str(0)



func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
