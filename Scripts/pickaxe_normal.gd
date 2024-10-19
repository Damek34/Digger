extends RigidBody2D

signal add_point(number)
signal load_result

var gold_number : int
var diamond_number : int
var ruby_number: int


var throw_force = 1200  # Siła rzutu, dostosuj według potrzeb
@onready var pickaxe_normal = $"."  # Odpowiednia ścieżka do obiektu
@onready var score = $"../CanvasLayer2/Score"
@onready var depth = $"../CanvasLayer2/Depth"
@onready var static_body_2d = $"../CanvasLayer/StaticBody2D"
@onready var you_lost = $"../CanvasLayer2/You lost"
@onready var ok = $"../CanvasLayer2/OK"
@onready var label_count_gold = $"../CanvasLayer2/GoldenOreBlock/LabelCountGold"
@onready var label_count_diamond: Label = $"../CanvasLayer2/DiamondOreBlock/LabelCountDiamond"
@onready var label_count_ruby: Label = $"../CanvasLayer2/RubyOreBlock/LabelCountRuby"
@onready var result: Label = $"../CanvasLayer2/GameModeResults/Result"
@onready var game_mode_results: TextureRect = $"../CanvasLayer2/GameModeResults"




var physics_material: PhysicsMaterial
@onready var camera_2d = $Camera2D
var score_number = 0
var highscore
var highest_pickaxe_y


func _ready():
	sleeping = false
	
	physics_material = PhysicsMaterial.new()
	physics_material.bounce = 0.43
	physics_material.friction = 0.4 
	
	physics_material_override = physics_material
	
	highest_pickaxe_y = floor((pickaxe_normal.global_position.y) / 80)

func _process(delta):
	depth.text = "DEPTH: " + str(floor((pickaxe_normal.global_position.y) / 80))
	label_count_gold.text = str(gold_number)
	label_count_diamond.text = str(diamond_number)
	label_count_ruby.text = str(ruby_number)
	
	if floor((pickaxe_normal.global_position.y) / 80) > highest_pickaxe_y:
		highest_pickaxe_y = floor((pickaxe_normal.global_position.y) / 80)




func _input(event):
	if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed):
		var target_position = event.position
		target_position = get_canvas_transform().affine_inverse().translated(event.position).origin

		var direction = (target_position - position).normalized()
		
		
		linear_velocity = direction * throw_force 
		



func _on_area_2d_body_entered(body):
	var name = body.name;
	name = name.substr(0, 4)
	if name == "mudd":
		body.emit_signal("got_damage", linear_velocity.length(), pickaxe_normal)

	if name == "gold":
		body.emit_signal("got_damage", linear_velocity.length(), pickaxe_normal)
	
	if name == "diam":
		body.emit_signal("got_damage", linear_velocity.length(), pickaxe_normal)
		
	if name == "ruby":
		body.emit_signal("got_damage", linear_velocity.length(), pickaxe_normal)
		
	if name == "bomb":
		body.emit_signal("explode")
		if Globals.game_mode_number == 0:
			you_lost.visible = true
			ok.visible = true
			loadData()
		else:
			game_mode_results.visible = true
			_on_load_result()
		get_tree().paused = true

func _on_add_point(number):
	score_number += number
	score.text = "Score: " + str(score_number)



func loadData():
	if FileAccess.file_exists(Globals.SAVE_FILE):
		var file = FileAccess.open(Globals.SAVE_FILE, FileAccess.READ)
		
		# Sprawdź, czy plik jest otwarty
		if file.is_open():
			var game_data = file.get_var()
			file.close()
			
			# Sprawdź, czy uzyskane dane są prawidłowe
			var highscore = game_data.get("highscore", 0)
			var max_depth = game_data.get("max_depth", 0)
			var total_gold = game_data.get("total_gold", 0)
			var total_diamonds = game_data.get("total_diamonds", 0)
			var total_rubies = game_data.get("total_rubies", 0)
			# Zapisz dane, korzystając z uzyskanych wartości
			save(highscore, max_depth, total_gold, total_diamonds, total_rubies)
		else:
			print("Nie udało się otworzyć pliku do odczytu.")
	else:
		print("Plik zapisu nie istnieje, używamy wartości domyślnych.")
		save(0, 0, 0, 0, 0)  # Użyj domyślnych wartości, jeśli plik nie istnieje

func save(highscore, max_depth, total_gold, total_diamonds, total_rubies):
	var game_data = {}
	
	# Sprawdzamy, czy nowe wartości są większe niż te istniejące i aktualizujemy dane
	if score_number > highscore:
		game_data["highscore"] = score_number
	else:
		game_data["highscore"] = highscore

	if highest_pickaxe_y > max_depth:
		game_data["max_depth"] = highest_pickaxe_y
	else:
		game_data["max_depth"] = max_depth
	
	game_data["total_gold"] = total_gold + gold_number
	game_data["total_diamonds"] = total_diamonds + diamond_number
	game_data["total_rubies"] = total_rubies + ruby_number
	
	
	# Zapisz dane do pliku
	var file = FileAccess.open(Globals.SAVE_FILE, FileAccess.WRITE)
	
	# Sprawdzenie, czy plik został otwarty
	if file.is_open():
		file.store_var(game_data)
		file.close()
	else:
		print("Nie udało się otworzyć pliku do zapisu.")


func _on_load_result() -> void:
	if Globals.game_mode_number == 1:
		result.text = "Score: " + str(score_number)
		
		var highscore = 0  # Domyślny wynik

		if FileAccess.file_exists(Globals.SAVE_BEST_SCORE_GAMEMODE):
			var file_read = FileAccess.open(Globals.SAVE_BEST_SCORE_GAMEMODE, FileAccess.READ)
			
			if file_read.is_open():
				var game_data = file_read.get_var()
				file_read.close()
				
				# Pobieranie najlepszego wyniku
				highscore = game_data.get("highscore", 0)
		
		# Jeśli nowy wynik jest wyższy, zapisz go
		if score_number > highscore:
			var file_write = FileAccess.open(Globals.SAVE_BEST_SCORE_GAMEMODE, FileAccess.WRITE)
			
			if file_write.is_open():
				var game_data = {}
				game_data["highscore"] = score_number
				file_write.store_var(game_data)
				file_write.close()
				print("Nowy rekord zapisany: " + str(score_number))
			else:
				print("Nie udało się otworzyć pliku do zapisu.")
		else:
			print("Wynik nie jest wyższy niż dotychczasowy rekord.")
			
			
			
			
	
	if Globals.game_mode_number == 2:
		result.text = "Max depth: " + str(highest_pickaxe_y)
		
		var highscore = 0  # Domyślny wynik

		if FileAccess.file_exists(Globals.SAVE_DEEPEST_DEPTH_GAMEMODE):
			var file_read = FileAccess.open(Globals.SAVE_DEEPEST_DEPTH_GAMEMODE, FileAccess.READ)
			
			if file_read.is_open():
				var game_data = file_read.get_var()
				file_read.close()
				
				# Pobieranie najlepszego wyniku
				highscore = game_data.get("highscore", 0)
		
		# Jeśli nowy wynik jest wyższy, zapisz go
		if highest_pickaxe_y > highscore:
			var file_write = FileAccess.open(Globals.SAVE_DEEPEST_DEPTH_GAMEMODE, FileAccess.WRITE)
			
			if file_write.is_open():
				var game_data = {}
				game_data["highscore"] = highest_pickaxe_y
				file_write.store_var(game_data)
				file_write.close()
				print("Nowy rekord zapisany: " + str(highest_pickaxe_y))
			else:
				print("Nie udało się otworzyć pliku do zapisu.")
		else:
			print("Wynik nie jest wyższy niż dotychczasowy rekord.")
	
	
	
	
	
	
	get_tree().paused = true
