extends Node2D



@onready var pickaxe = $Pickaxe
@onready var static_body_2d = $CanvasLayer/StaticBody2D
@onready var ok_button = $CanvasLayer2/OK
@onready var warning_texture_rect = $CanvasLayer2/WarningTextureRect
@onready var golden_ore_block: Sprite2D = $CanvasLayer2/GoldenOreBlock
@onready var ruby_ore_block: Sprite2D = $CanvasLayer2/RubyOreBlock
@onready var diamond_ore_block: Sprite2D = $CanvasLayer2/DiamondOreBlock
@onready var timer: Timer = $CanvasLayer2/Time/Timer
@onready var time: Label = $CanvasLayer2/Time
@onready var result: Label = $CanvasLayer2/GameModeResults/Result
@onready var game_mode_results: TextureRect = $CanvasLayer2/GameModeResults
@onready var ok_result: Button = $CanvasLayer2/GameModeResults/OKResult


var blocks_x = [90, 270, 450, 630, 810, 990]
const blocks_min_y = 1050
const blocks_y_space = 180
var highest_pickaxe_y
var block_rng = RandomNumberGenerator.new()

var mud_block = preload("res://Scenes/mud.tscn")
var bombs = preload("res://Scenes/bomb.tscn")
var gold_ore = preload("res://Scenes/gold.tscn")
var diamond_ore = preload("res://Scenes/diamond.tscn")
var ruby_ore = preload("res://Scenes/ruby.tscn")

@onready var score = $CanvasLayer2/Score

var block_counter = 0
var bombs_counter = 0
var gold_counter = 0
var diamond_counter = 0
var ruby_counter = 0



var remaining_time = 180

func _ready():
	highest_pickaxe_y = pickaxe.global_position.y
	ok_result.process_mode = Node.PROCESS_MODE_ALWAYS
	if Globals.show_digged:
		golden_ore_block.visible = true
		diamond_ore_block.visible = true
		ruby_ore_block.visible = true
	else:
		golden_ore_block.visible = false
		diamond_ore_block.visible = false
		ruby_ore_block.visible = false
		
	if Globals.game_mode_number == 1 or Globals.game_mode_number == 2:
		time.visible = true
		timer.start(1)
		update_timer_label()
	else:
		time.visible = false


func update_timer_label():
	var minutes = int(remaining_time / 60)  # Oblicz minuty
	var seconds = remaining_time % 60  # Oblicz sekundy
	
	# Sformatuj tekst (np. "02:59")
	var time_text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	# Aktualizacja tekstu w Label
	time.text = "Time: " + time_text

func _on_timer_timeout() -> void:
	if remaining_time > 0:
		remaining_time -= 1  # Zmniejszamy czas o 1 sekundę
		update_timer_label()  # Aktualizujemy tekst
	else:
		timer.stop()  # Zatrzymaj timer, gdy czas dobiegnie końca
		game_mode_results.visible = true
		pickaxe.emit_signal("load_result")


func _process(delta):
	if pickaxe != null:
		
		static_body_2d.position.y = pickaxe.global_position.y
		if (pickaxe.global_position.y - highest_pickaxe_y) > blocks_y_space:
			highest_pickaxe_y = pickaxe.global_position.y
			
			var blocks_number = floor(block_rng.randf_range(0, 5))

			var available_locations = blocks_x.duplicate()

			# Tworzenie bloków
			for i in range(blocks_number):
				if available_locations.size() > 0:
					var random_index = block_rng.randi_range(0, available_locations.size() - 1)
					var localization_x = available_locations[random_index]
					available_locations.remove_at(random_index)
					
					var block_type = randi() % 100 
					
					if block_type < 82:
						var new_block = mud_block.instantiate()
						new_block.name = "mudd_" + str(block_counter)
						block_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)
					
					elif block_type < 92:
						var new_block = gold_ore.instantiate()
						new_block.name = "gold" + str(gold_counter)
						gold_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)
					elif block_type < 97:
						var new_block = bombs.instantiate()
						new_block.name = "bomb" + str(bombs_counter)
						bombs_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)
					elif block_type < 99:
						var new_block = ruby_ore.instantiate()
						new_block.name = "ruby" + str(ruby_counter)
						ruby_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)
						
					elif block_type < 100:
						var new_block = diamond_ore.instantiate()
						new_block.name = "diam" + str(diamond_counter)
						diamond_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)


func _on_home_pressed():
	warning_texture_rect.visible = true
	get_tree().paused = true


func _on_ok_result_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
