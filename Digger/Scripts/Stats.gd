extends Node2D

@onready var digged_gold = $Control/ColorRect/DiggedGold
@onready var digged_diamonds = $Control/ColorRect/DiggedDiamonds

func _ready():
	var config = ConfigFile.new()
	
	var err = config.load("user://settings.cfg")
	if err == OK:
		var gold = config.get_value("game", "total_gold", 0)
		var diamonds = config.get_value("game", "total_diamonds", 0)
		
		digged_gold.text = digged_gold.text + " " + str(gold)
		digged_diamonds.text = digged_diamonds.text + " " + str(diamonds)
	else:
		digged_gold.text = str(0)



func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
