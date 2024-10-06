extends Node2D



@onready var pickaxe = $Pickaxe
@onready var static_body_2d = $CanvasLayer/StaticBody2D

var blocks_x = [90, 270, 450, 630, 810, 990]
const blocks_min_y = 1050
const blocks_y_space = 180
var highest_pickaxe_y
var block_rng = RandomNumberGenerator.new()

var mud_block = preload("res://Scenes/mud.tscn")
var bombs = preload("res://Scenes/bomb.tscn")
var gold_ore = preload("res://Scenes/gold.tscn")

@onready var score = $CanvasLayer2/Score

var block_counter = 0
var bombs_counter = 0
var gold_counter = 0
var score_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	highest_pickaxe_y = pickaxe.global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pickaxe != null:
		
		static_body_2d.position.y = pickaxe.global_position.y
		if (pickaxe.global_position.y - highest_pickaxe_y) > blocks_y_space:
			highest_pickaxe_y = pickaxe.global_position.y
			
			var blocks_number = floor(block_rng.randf_range(0, 5))

			# Kopiujemy listę dostępnych lokalizacji na początku, przed pętlą
			var available_locations = blocks_x.duplicate()

			# Tworzenie bloków
			for i in range(blocks_number):
				if available_locations.size() > 0:
					var random_index = block_rng.randi_range(0, available_locations.size() - 1)
					var localization_x = available_locations[random_index]
					available_locations.remove_at(random_index)  # Usuwamy zajęte miejsce
					
					var block_type = randi() % 100  # Losowa liczba od 0 do 99
					
					if block_type < 85:
						var new_block = mud_block.instantiate()
						new_block.name = "mudd_" + str(block_counter)
						block_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)
					
					elif block_type < 95:
						var new_block = gold_ore.instantiate()
						new_block.name = "gold" + str(gold_counter)
						gold_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)
					elif block_type < 100:
						var new_block = bombs.instantiate()
						new_block.name = "bomb" + str(bombs_counter)
						bombs_counter += 1
						new_block.position = Vector2(localization_x, highest_pickaxe_y + (blocks_y_space * 7))
						new_block.pickaxe = pickaxe
						add_child(new_block)
