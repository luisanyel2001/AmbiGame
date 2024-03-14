extends Node3D
@onready var target1 = get_node("../salida1")
@onready var target2 = get_node("../salida2")
@onready var target3 = get_node("../salida3")
@onready var targets = [target1, target2, target3]

var tiempoTotalDeciciones = 0.0
var numDecisiones = 0
var tiempoInicioDecicion = 0.0
var tiempoTotal = 0.0
var destino = 0
var salida_destino = ""
var destinosCorrectos = 0
var destinosIncorrectos = 0
var velocidadPromedio = 0
var tiempoPartida = 0
var tiempoDeciciones = 0
var vehicle 
var promedio_tiempo_decision = 0

func _calculoAmbiguedad():
	#print("La velocidad promedio del vehículo es desde el scrpt del NIVEL: ", vehicle.velocidad_promedio, " unidades por segundo")
	velocidadPromedio = vehicle.velocidad_promedio	
	if numDecisiones > 0:
		promedio_tiempo_decision = tiempoTotalDeciciones / numDecisiones
		promedio_tiempo_decision = promedio_tiempo_decision/1000
	print("Promedio de tiempo de decisión: " + str(promedio_tiempo_decision) + " ms")
	print("El tiempo total de la partida es: ", tiempoTotal, " segundos")	
	print("velocidad promedio = ", velocidadPromedio)
	print("puntos correctos = ", destinosCorrectos)
	print("puntos incorrectos = ", destinosIncorrectos)
	var toleranciaAmbiguedad = (destinosCorrectos/(destinosCorrectos+destinosIncorrectos))
	toleranciaAmbiguedad -= promedio_tiempo_decision/tiempoTotal
	toleranciaAmbiguedad += velocidadPromedio/tiempoTotal
	print("LA TOLERANCIA A LA AMBIGUEDAD ES DE: " , toleranciaAmbiguedad)
	


var pause_menu: PackedScene
# Called when the node enters the scene tree for the first time.


func _ready():
	vehicle = get_node("car")
	_nuevoDestino()

<<<<<<< Updated upstream
	set_process_input(true)
	pause_menu = preload("res://UI/menu_pausa_2.tscn")
	
	hide_textbox()
	var gano = queue_text("Haz ganado ...")
	queue_text("Continua yendo hacia ... ")
	queue_text("Textooooo treees")
	
	destino = randi() % targets.size()
	if(destino == 0):
		salida_destino = "salida1"
	elif (destino == 1):
		salida_destino = "salida2"
	elif (destino == 2):
		salida_destino = "salida3"
	print("destino: " + salida_destino)
=======
	#hide_textbox()	
>>>>>>> Stashed changes

	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request("https://luisanyel.000webhostapp.com/crearUsuario.json")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	"""	
	var road = get_node("NavigationRegion3D/laberintoTuneles/road_tunnel")
	var area = road.get_node("Area3D") as Area3D
	area.body_entered.connect(_entro)
	"""
	"""
	$salida1/Area3D.body_entered.connect(func(body): _entro(body, $salida1/Area3D))
	$salida2/Area3D.body_entered.connect(func(body): _entro(body, $salida2/Area3D))
	$salida3/Area3D.body_entered.connect(func(body): _entro(body, $salida3/Area3D))
<<<<<<< Updated upstream
	"""
=======
	#interseccion1
	var interseccion1 = get_node("NavigationRegion3D/laberintoTuneles/intersection_tunnel")
	var areaCenter1 = interseccion1.get_node("Area3D_center")
	var areaRight1 = interseccion1.get_node("Area3D_right")
	var areaLeft1 = interseccion1.get_node("Area3D_left")
	areaCenter1.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_center"))		
	areaRight1.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_right"))
	areaLeft1.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_left"))
	#interseccion2
	var interseccion2 = get_node("NavigationRegion3D/laberintoTuneles/intersection_tunnel2")
	var areaCenter2 = interseccion2.get_node("Area3D_center")
	var areaRight2 = interseccion2.get_node("Area3D_right")
	var areaLeft2 = interseccion2.get_node("Area3D_left")
	areaCenter2.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_center"))		
	areaRight2.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_right"))
	areaLeft2.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_left"))
	#interseccion3
	var interseccion3 = get_node("NavigationRegion3D/laberintoTuneles/intersection_tunnel3")
	var areaCenter3 = interseccion3.get_node("Area3D_center")
	var areaRight3 = interseccion3.get_node("Area3D_right")
	var areaLeft3 = interseccion3.get_node("Area3D_left")
	areaCenter3.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_center"))		
	areaRight3.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_right"))
	areaLeft3.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_left"))
	#interseccion4
	var interseccion4 = get_node("NavigationRegion3D/laberintoTuneles/intersection_tunnel4")
	var areaCenter4 = interseccion4.get_node("Area3D_center")
	var areaRight4 = interseccion4.get_node("Area3D_right")
	var areaLeft4 = interseccion4.get_node("Area3D_left")
	areaCenter4.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_center"))		
	areaRight4.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_right"))
	areaLeft4.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_left"))
	#interseccion5
	var interseccion5 = get_node("NavigationRegion3D/laberintoTuneles/intersection_tunnel5")
	var areaCenter5 = interseccion5.get_node("Area3D_center")
	var areaRight5 = interseccion5.get_node("Area3D_right")
	var areaLeft5 = interseccion5.get_node("Area3D_left")
	areaCenter5.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_center"))		
	areaRight5.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_right"))
	areaLeft5.body_entered.connect(func(body): _entroInterseccion(body, "Area3D_left"))
	
func _entroInterseccion(body, area):
	print("area 3d interseccionnnnn")
	print(body.to_string())
	print(area)
	if(area == "Area3D_center"):
		print("INICIAR CONTADOR DECICION")		
		tiempoInicioDecicion = Time.get_ticks_msec()
	else:
		print("DETENER CONTADOR DECICION")
		var tiempoDecision = Time.get_ticks_msec() - tiempoInicioDecicion
		tiempoTotalDeciciones += tiempoInicioDecicion
		numDecisiones += 1
	
func _nuevoDestino():
	destino = randi() % targets.size()
	if(destino == 0):
		salida_destino = "salida1"
	elif (destino == 1):
		salida_destino = "salida2"
	elif (destino == 2):
		salida_destino = "salida3"
	print("destino: " + salida_destino)
>>>>>>> Stashed changes
			
func _entro(body, area):
	if(body == $car):		
		if(salida_destino == area.get_parent().name):
<<<<<<< Updated upstream
			print("Entro123 " + body.to_string())
			print("El objeto entró en el área: " + area.name)
			print("El nodo padre del área es: " + area.get_parent().name)
=======
			destinosCorrectos += 1
			print("correcto: ", destinosCorrectos)
			_nuevoDestino()
		else:
			destinosIncorrectos += 1
			print("incorrecto: ", destinosIncorrectos)
			_nuevoDestino()


	
	
	
	
	
>>>>>>> Stashed changes
	$NavigationRegion3D/laberintoTuneles/road_tunnel/Area3D.body_entered.connect(_entro)
	
	var a = $NavigationRegion3D/laberintoTuneles/road_tunnel2/Area3D as Area3D 

<<<<<<< Updated upstream

=======
	
	# Inicializa el cuadro de texto y su funcionalidad aquí
	change_state(State.READY)
	print("Iniciando: State.READY")
	hide_textbox()
	queue_text("Este texto es creado desde el script")
	queue_text("Texto2 colaaa")
	queue_text("Textooooo treees")
	show_textbox() 
	
>>>>>>> Stashed changes
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()

	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(response.glossary['title'])
	#$NavigationRegion3D/laberintoTuneles/road_tunnel/Label3D.text = response.glossary['title']
	$Label3D.text = response.glossary['title']


#########################################################

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
		tiempoTotal += delta
		match current_state:
			State.INACTIVE:
				pass
			State.READY:
				if !text_queue.is_empty():
					display_text()
			State.READING:
				if not is_text_displayed and current_char < current_text.length():
					char_timer += delta
					if char_timer > CHAR_READ_RATE:
						label.text += current_text[current_char]
						current_char += 1
						char_timer = 0.0
				else:
					# Detener el proceso cuando se haya mostrado todo el texto
					is_text_displayed = true  # Se ha mostrado todo el texto
					change_state(State.FINISHED)

			State.FINISHED:
				if Input.is_action_just_pressed("ui_accept"): #Al finalizar presionar enter para quitar textbox
					change_state(State.READY)
					hide_textbox()
	
<<<<<<< Updated upstream


const CHAR_READ_RATE = 0.02
=======
const CHAR_READ_RATE = 0.05
>>>>>>> Stashed changes

@onready var textbox_container = $Textbox/TextboxContainer
@onready var start_symbol = $Textbox/TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $Textbox/TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $Textbox/TextboxContainer/MarginContainer/HBoxContainer/Label

enum State{
	 READY,
	 READING,
	 FINISHED,
	 INACTIVE
}

var current_state = State.INACTIVE
var text_queue = []

#animacion letras
var current_text = ""
var current_char = 0
var char_timer = 0.0
var is_text_displayed = false 

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	#if current_state == State.READY:
		var next_text = text_queue.pop_front()
		current_text = next_text
		change_state(State.READING)
		label.text = ""
		show_textbox()
		current_char = 0
		char_timer = 0.0
		is_text_displayed = false  # Reiniciar is_text_displayed cuando se agrega nuevo texto

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Cambiando estado a: State.READY")
		State.READING:
			print("Cambiando estado a: State.READING")
		State.FINISHED:
			print("Cambiando estado a: State.FINISHED")
		State.INACTIVE:
			print("Cambiando estado a: State.INACTIVE")

func _on_area_3d_body_entered(body):
	print("ooooo" + gano) 
	change_state(State.READY)

func _on_area_3d_body_exited(body):
	change_state(State.FINISHED)
	hide_textbox()
	
<<<<<<< Updated upstream

############# PAUSA ##################################
=======
############ PAUSA PRUEBA
var pause_menu_instance = null
>>>>>>> Stashed changes

func _input(event):
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.keycode == KEY_P and key_event.pressed:
<<<<<<< Updated upstream
			$MenuPausa3.show()
			#toggle_pause()
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.keycode == KEY_ESCAPE and key_event.pressed:
			$MenuPausa3.hide()
=======
			toggle_pause_menu()
		if key_event.keycode == KEY_ESCAPE and key_event.pressed:
			_calculoAmbiguedad()
				
func toggle_pause_menu() -> void:
	if not pause_menu_instance:
		# Cargar la escena PauseMenu.tscn
		var pause_menu_scene = preload("res://UI/PauseMenu.tscn")

		# Instanciar la escena cargada
		pause_menu_instance = pause_menu_scene.instance()

		# Agregar la instancia como hijo del nodo raíz
		get_tree().get_root().add_child(pause_menu_instance)

		# Pausar el juego
		get_tree().paused = true
	else:
		# Quitar la escena de pausa si ya está presente
		pause_menu_instance.queue_free()
		pause_menu_instance = null

		# Reanudar el juego
		get_tree().paused = false
>>>>>>> Stashed changes
