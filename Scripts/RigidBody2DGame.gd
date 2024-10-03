extends RigidBody2D

var throw_force = 1000  # Siła rzutu, dostosuj według potrzeb
var physics_material: PhysicsMaterial
# Called when the node enters the scene tree for the first time.
func _ready():
	sleeping = false
	
	# Tworzenie materiału fizycznego
	physics_material = PhysicsMaterial.new()
	physics_material.bounce = 0.43  # Ustaw odbicie
	physics_material.friction = 0.4  # Ustaw tarcie

	# Przypisz materiał fizyczny do obiektu
	physics_material_override = physics_material



func _input(event):
	# Sprawdzenie, czy zdarzenie dotyku lub kliknięcia myszką wystąpiło
	if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed):
		# Pobranie pozycji dotknięcia lub kliknięcia
		var target_position = event.position
		
		# Przesunięcie pozycji do współrzędnych świata, jeśli potrzebne
		target_position = get_global_mouse_position() if event is InputEventMouseButton else target_position
		
		# Oblicz kierunek do pozycji docelowej
		var direction = (target_position - position).normalized()  # Oblicza kierunek
		
		# Ustawienie prędkości w kierunku docelowym
		linear_velocity = direction * throw_force  # Ustawia prędkość na podstawie kierunku i prędkości
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
