extends VehicleBody3D

var draggin = false
var volante 
var rotacion_inicial 
var max_rotacion = 145  # El máximo ángulo de rotación permitido
# Called when the node enters the scene tree for the first time.
func _ready():
	print("lo que sea")
	volante = get_node("volante")
	rotacion_inicial = volante.rotate_z
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	#steering = Input.get_axis("right", "left") * .4
	if(draggin):
		steering = -volante.rotation_degrees.z / 200.0
	else:
		steering = 0
	engine_force = Input.get_axis("back", "forward") * 100
	
func _on_volante_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("el jugador hizo clic en el colante")
		
func _input(event):
	if(event is InputEventMouseButton):
		if event.is_pressed():
			draggin = true
		else:			
			draggin = false
			volante.rotation_degrees.z = 0
	elif event is InputEventMouseMotion and draggin:
		var rotacion = volante.rotation_degrees.z + deg_to_rad(event.relative.x)
		volante.rotation_degrees.z = clamp(rotacion, -max_rotacion, max_rotacion)
		volante.rotate_z(deg_to_rad(event.relative.x))	
		# El jugador está arrastrando el mouse, gira el volante




