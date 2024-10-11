extends Node2D



@onready var pickaxe = $Pickaxe
@onready var static_body_2d = $CanvasLayer/StaticBody2D
@onready var ok_button = $CanvasLayer2/OK
@onready var warning_texture_rect = $CanvasLayer2/WarningTextureRect
@onready var golden_ore_block = $CanvasLayer2/GoldenOreBlock
@onready var diamond_ore_block = $CanvasLayer2/GoldenOreBlock/DiamondOreBlock

var blocks_x = [90, 270, 450, 630, 810, 990]
const blocks_min_y = 1050
const blocks_y_space = 180
var highest_pickaxe_y
var block_rng = RandomNumberGenerator.new()

var mud_block = preload("res://Scenes/mud.tscn")
var bombs = preload("res://Scenes/bomb.tscn")
var gold_ore = preload("res://Scenes/gold.tscn")
var diamond_ore = preload("res://Scenes/diamond.tscn")

@onready var score = $CanvasLayer2/Score

var block_counter = 0
var bombs_counter = 0
var gold_counter = 0
var diamond_counter = 0

var score_number = 0


func _ready():
	highest_pickaxe_y = pickaxe.global_position.y
	
	if Globals.show_digged:
		golden_ore_block.visible = true
		diamond_ore_block.visible = true
	else:
		golden_ore_block.visible = false
		diamond_ore_block.visible = false


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
					
					if block_type < 84:
						var new_block = mud_block.instantiate()
						new_block.name = "mudd_" + str(block_counter)
						block_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)
					
					elif block_type < 94:
						var new_block = gold_ore.instantiate()
						new_block.name = "gold" + str(gold_counter)
						gold_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)
					elif block_type < 99:
						var new_block = bombs.instantiate()
						new_block.name = "bomb" + str(bombs_counter)
						bombs_counter += 1
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
