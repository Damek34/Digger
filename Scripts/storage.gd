extends Node2D

@onready var steel_check: Sprite2D = $Control/ColorRect/SteelPickaxe/SteelCheck
@onready var golden_check: Sprite2D = $Control/ColorRect/GoldenPickaxe/GoldenCheck
@onready var iron_check: Sprite2D = $Control/ColorRect/IronPickaxe/IronCheck
@onready var diamond_check: Sprite2D = $Control/ColorRect/DiamondPickaxe/DiamondCheck
@onready var ruby_check: Sprite2D = $Control/ColorRect/RubyPickaxe/RubyCheck
@onready var unlock: TextureRect = $Control/ColorRect/Unlock
@onready var unlock_text: Label = $Control/ColorRect/Unlock/UnlockText
@onready var ability_text: Label = $Control/ColorRect/Unlock/AbilityText
@onready var select: TextureRect = $Control/ColorRect/Select
@onready var ability_text_select: Label = $Control/ColorRect/Select/AbilityText
@onready var golden_locked: Sprite2D = $Control/ColorRect/GoldenPickaxe/GoldenLocked
@onready var iron_locked: Sprite2D = $Control/ColorRect/IronPickaxe/IronLocked
@onready var diamond_locked: Sprite2D = $Control/ColorRect/DiamondPickaxe/DiamondLocked
@onready var ruby_locked: Sprite2D = $Control/ColorRect/RubyPickaxe/RubyLocked

var unlocking_id
var selecting_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.selected_pickaxe_id == 0:
		steel_check.visible = true
		golden_check.visible = false
		iron_check.visible = false
		diamond_check.visible = false
		ruby_check.visible = false
	if Globals.selected_pickaxe_id == 1:
		steel_check.visible = false
		golden_check.visible = true
		iron_check.visible = false
		diamond_check.visible = false
		ruby_check.visible = false
	
	
	
	if !Globals.is_golden_pickaxe_available:
		golden_locked.visible = true
	
	if !Globals.is_iron_pickaxe_available:
		iron_locked.visible = true
	
	if !Globals.is_diamond_pickaxe_available:
		diamond_locked.visible = true
	
	if !Globals.is_ruby_pickaxe_available:
		ruby_locked.visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_steel_pickaxe_pressed() -> void:
	selecting_id = 0
	select.visible = true
	ability_text_select.text = "Default steel pickaxe"
	ability_text_select.add_theme_color_override("font_color", Color8(168, 191, 191))
	
	
	
	
	print(str(Globals.is_golden_pickaxe_available))

func _on_golden_pickaxe_pressed() -> void:
	#print(str(Globals.is_golden_pickaxe_available))
	if Globals.is_golden_pickaxe_available:
		unlock.visible = false
		select.visible = true
		selecting_id = 1
		ability_text_select.text = "Golden pickaxe\n\nMining 7% faster"
		ability_text_select.add_theme_color_override("font_color", Color8(255, 215, 0))
	else:
		select.visible = false
		unlocking_id = 1
		unlock.visible = true
		unlock_text.text = "To unlock this pickaxe, you must mine at least 1000 gold blocks. You can check your progress in the statistics tab"
		ability_text.text = "Golden pickaxe\n\nMining 7% faster"
		ability_text.add_theme_color_override("font_color", Color8(255, 215, 0))

func _on_unlock_button_pressed() -> void:
	var digged_gold = check_if_can_be_unlocked()
	if unlocking_id == 1:
		if digged_gold >= 1000:
			steel_check.visible = false
			golden_check.visible = true
			iron_check.visible = false
			diamond_check.visible = false
			ruby_check.visible = false
			Globals.selected_pickaxe_id = 1
			unlock.visible = false
			
			Globals.is_golden_pickaxe_available = true
			save_unlocked_pickaxe()
		else:
			print("Error")

func check_if_can_be_unlocked():
	if FileAccess.file_exists(Globals.SAVE_FILE):
		var file = FileAccess.open(Globals.SAVE_FILE, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var game_data = file.get_var()
			file.close()
			if unlocking_id == 1:
				return int(game_data.get("total_gold", 0))
			#var total_diamonds = game_data.get("total_diamonds", 0)
			#var total_rubies = game_data.get("total_rubies", 0)
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
			return 0

	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		return 0

func save_unlocked_pickaxe():
	var pickaxes = {}

	pickaxes["golden"] = Globals.is_golden_pickaxe_available
	pickaxes["iron"] = Globals.is_iron_pickaxe_available
	pickaxes["diamond"] = Globals.is_diamond_pickaxe_available
	pickaxes["ruby"] = Globals.is_ruby_pickaxe_available

	
	# Zapisz dane do pliku
	var file = FileAccess.open(Globals.SAVE_AVAILABLE_PICKAXES, FileAccess.WRITE)
	
	# Sprawdzenie, czy plik został otwarty
	if file.is_open():
		file.store_var(pickaxes)
		file.close()
		print("Dane zapisane pomyślnie.")
	else:
		print("Nie udało się otworzyć pliku do zapisu.")


func _on_select_button_pressed() -> void:
	if selecting_id == 0:
		steel_check.visible = true
		golden_check.visible = false
		iron_check.visible = false
		diamond_check.visible = false
		ruby_check.visible = false
		unlock.visible = false
		Globals.selected_pickaxe_id = 0
		select.visible = false
		save_selected()
	
	if selecting_id == 1:
		steel_check.visible = false
		golden_check.visible = true
		iron_check.visible = false
		diamond_check.visible = false
		ruby_check.visible = false
		unlock.visible = false
		Globals.selected_pickaxe_id = 1
		select.visible = false
		save_selected()


func save_selected():
	var pickaxe = {}
	pickaxe["pickaxe"] = Globals.selected_pickaxe_id
	# Zapisz dane do pliku
	var file = FileAccess.open(Globals.SAVE_SELECTED_PICKAXE, FileAccess.WRITE)
	
	# Sprawdzenie, czy plik został otwarty
	if file.is_open():
		file.store_var(pickaxe)
		file.close()
		print("Dane zapisane pomyślnie.")
	else:
		print("Nie udało się otworzyć pliku do zapisu.")
