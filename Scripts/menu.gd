extends Node2D

@onready var my_highcore = $Control/ColorRect/MyHighcore

func _ready():
	var config = ConfigFile.new()
	
	var err = config.load("user://settings.cfg")
	if err == OK:
		var highscore = config.get_value("game", "highscore", 0) 
		my_highcore.text = str(highscore)
		return highscore
	else:
		my_highcore.text = str(0)


func _on_settings_pressed():
		get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_stats_pressed():
	get_tree().change_scene_to_file("res://Scenes/stats.tscn")
