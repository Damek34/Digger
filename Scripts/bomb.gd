extends StaticBody2D

var pickaxe : RigidBody2D

signal explode

@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _ready():
	audio_stream_player_2d.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	# Sprawdzamy, czy obiekt jest odpowiednio oddalony od pickaxe
	if pickaxe != null and pickaxe and global_position.y < pickaxe.global_position.y - 4500:
		queue_free()
	

func _on_explode():
	audio_stream_player_2d.play()
