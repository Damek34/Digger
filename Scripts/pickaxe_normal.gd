extends RigidBody2D

signal add_point(number)

var gold_number : int


var throw_force = 1200  # Siła rzutu, dostosuj według potrzeb
@onready var pickaxe_normal = $"."  # Odpowiednia ścieżka do obiektu
@onready var score = $"../CanvasLayer2/Score"
@onready var depth = $"../CanvasLayer2/Depth"
@onready var static_body_2d = $"../CanvasLayer/StaticBody2D"
@onready var you_lost = $"../CanvasLayer2/You lost"
@onready var ok = $"../CanvasLayer2/OK"



var physics_material: PhysicsMaterial
@onready var camera_2d = $Camera2D
var score_number = 0
var highscore


func _ready():
	# Wyłączenie spania, aby kilof był zawsze aktywny
	sleeping = false
	
	# Tworzenie materiału fizycznego
	physics_material = PhysicsMaterial.new()
	physics_material.bounce = 0.43  # Ustaw odbicie
	physics_material.friction = 0.4  # Ustaw tarcie
	

	# Przypisz materiał fizyczny do obiektu
	physics_material_override = physics_material

func _process(delta):
	depth.text = "DEPTH: " + str(floor((pickaxe_normal.global_position.y) / 30))




func _input(event):
	# Sprawdzenie, czy zdarzenie dotyku lub kliknięcia myszką wystąpiło
	if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed):
		# Pobranie pozycji dotknięcia lub kliknięcia
		var target_position = event.position
		
		# Przesunięcie pozycji do współrzędnych świata, jeśli potrzebne
	#$target_position = get_global_mouse_position() if event is InputEventMouseButton else target_position
		target_position = get_canvas_transform().affine_inverse().translated(event.position).origin
		# Oblicz kierunek do pozycji docelowej
		var direction = (target_position - position).normalized()  # Oblicza kierunek
		
		# Ustawienie prędkości w kierunku docelowym
		linear_velocity = direction * throw_force  # Ustawia prędkość na podstawie kierunku i prędkości
		
		



func _on_area_2d_body_entered(body):
	var name = body.name;
	name = name.substr(0, 4)
	if name == "mudd":
		body.emit_signal("got_damage", linear_velocity.length(), pickaxe_normal)

	if name == "gold":
		body.emit_signal("got_damage", linear_velocity.length(), pickaxe_normal)

	if name == "bomb":
		body.emit_signal("explode")
		you_lost.visible = true
		ok.visible = true
		#pickaxe_normal.queue_free()
		#Engine.time_scale = 0.0
		readHighscore()
		get_tree().paused = true

func _on_add_point(number):
	score_number += number
	score.text = "Score: " + str(score_number)


func readHighscore():
	var config = ConfigFile.new()
	
	# Otwórz plik konfiguracyjny
	var err = config.load("user://settings.cfg")
	if err == OK:
		# Pobierz wynik z sekcji "game" i klucza "highscore"
		highscore = config.get_value("game", "highscore", 0)  # Domyślna wartość to 0, jeśli nie istnieje
		var total_gold = config.get_value("game", "total_gold", 0)
		
		saveMinerals(total_gold)
		
		#print("Załadowano wynik:", highscore)
		if score_number > highscore:
			saveHighscore()
	else:
		highscore = 0



func saveHighscore():
	var config = ConfigFile.new()
	# Otwórz plik konfiguracyjny (lub utwórz, jeśli nie istnieje)
	var err = config.load("user://settings.cfg")
	if err != OK:
		print("Nie udało się otworzyć pliku konfiguracyjnego.")
	
	# Ustaw nowy wynik w sekcji "game" z kluczem "highscore"
	config.set_value("game", "highscore", score_number)
	
	# Zapisz plik
	config.save("user://settings.cfg")
	#print("Zapisano wynik:", score_number)
	
	

func saveMinerals(total_gold):
	var config = ConfigFile.new()
	# Otwórz plik konfiguracyjny (lub utwórz, jeśli nie istnieje)
	var err = config.load("user://settings.cfg")
	if err != OK:
		print("Nie udało się otworzyć pliku konfiguracyjnego.")
	
	# Ustaw nowy wynik w sekcji "game" z kluczem "highscore"
	config.set_value("game", "total_gold", total_gold + gold_number)
	
	# Zapisz plik
	config.save("user://settings.cfg")
	print("Zapisano złoto:", total_gold + gold_number)
	
