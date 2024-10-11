extends StaticBody2D

var pickaxe : RigidBody2D

signal got_damage(damage, pickaxe)
var hp = 4000

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer


func _ready():
	audio_stream_player_2d.process_mode = Node.PROCESS_MODE_ALWAYS
func _process(delta):
	if pickaxe != null and pickaxe and global_position.y < pickaxe.global_position.y - 4500:
		queue_free()
	
func _on_got_damage(damage, pickaxe):
	hp = hp - damage
	if(hp <= 0):
		audio_stream_player_2d.play()
		pickaxe.emit_signal("add_point", 5)
		visible = false
		pickaxe.gold_number += 1
		collision_shape_2d.queue_free()
		timer.start()



func _on_timer_timeout():
	queue_free()
