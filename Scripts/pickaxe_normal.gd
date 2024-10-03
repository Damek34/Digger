extends RigidBody2D

signal add_point(number)

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
	
	#if name == "mudd" and linear_velocity.length() > 500 :
		#body.queue_free()
		#linear_velocity = linear_velocity / 2
		#addPoint(2)
		
		#return
	
	if name == "bomb":
		body.emit_signal("explode")
		you_lost.visible = true
		ok.visible = true
		Engine.time_scale = 0.0
		
		

func _on_add_point(number):
	score_number += number
	score.text = "Score: " + str(score_number)
