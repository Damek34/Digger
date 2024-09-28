extends Control
@onready var timer = $"../Timer"


func _on_animation_player_animation_finished(anim_name):
	timer.start()



func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
