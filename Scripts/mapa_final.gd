@tool #Descomentar para ver vista previa
extends Node3D
#Init peticiones
var http_request = HTTPRequest.new()

#variables IA ;D
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



func _deteccion_area_ciudad(id, body):
	print("Se activo el area de " + id + " y entro un " + body.to_string())
	"""
	if id == objetivo_nivel:
		gano = true
		Global.gano = true
		_cargar_siguiente_nivel()
		$MenuPausa3/Label/Label.text = "Tu objetivo es: " + objetivo_nivel
	else:
		perdio = true
		Global.perdio = true
		
	reiniciar = true
	_carga_UI(gano)
	_carga_IA(gano)
	"""

func _carga_nivel(result, response_code, headers, body):
	var json = JSON.new()
	var response
	#Obtiene el json del mapa, mediante http y en caso de error por archivo local
	if response_code != 200:
		print("Leido por local")
		var file = FileAccess.open("res://Scripts/mapa.json", FileAccess.READ)
		var content = file.get_as_text()
		json.parse(content)
		response = json.get_data()
	else:
		print("Leido por http")
		json.parse(body.get_string_from_utf8())
		response = json.get_data()
	
	#Cambia letreros e inicia indicaciones
	print(str(Global.numero_nivel_actual))
	Global.objetivo_nivel = response.niveles[str(Global.numero_nivel_actual)]['objetivo']
	$MenuPausa3/Label/Label.text = "Tu objetivo es: " + Global.objetivo_nivel
	##mostrar_texto_inicio()
	
	#Cargar nombre ciudades y Vincula areas3D de las ci
	for i in range(1,13):	
		get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Letrero_aereo/Label3D").text = response.ciudades[str(i)]
		get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Area3D").body_entered.connect(func(body):_deteccion_area_ciudad(response.ciudades[str(i)], body))
		#Recorre los letreros
		
		
	for interseccion in range(1,14):	
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/Area3D_left").body_entered.connect(_interseccion_area)
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/Area3D_right").body_entered.connect(_interseccion_area)
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/Area3D_center").body_entered.connect(_interseccion_area)
		for letrero in range(1,4):
			#Letrero izquierda
			
			get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/doble_signs_izq/left_signs/Label3D"+str(letrero)).text = response.niveles[str(Global.numero_nivel_actual)]["intersecciones"][str(interseccion)]["seniales_izq"]["izquierda"][str(letrero)]

			get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/doble_signs_izq/right_signs/Label3D"+str(letrero)).text = response.niveles[str(Global.numero_nivel_actual)]["intersecciones"][str(interseccion)]["seniales_izq"]["derecha"][str(letrero)]
			#Letrero derecha
			get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/doble_signs_der/left_signs/Label3D"+str(letrero)).text = response.niveles[str(Global.numero_nivel_actual)]["intersecciones"][str(interseccion)]["seniales_der"]["izquierda"][str(letrero)]
			get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/doble_signs_der/right_signs/Label3D"+str(letrero)).text = response.niveles[str(Global.numero_nivel_actual)]["intersecciones"][str(interseccion)]["seniales_der"]["derecha"][str(letrero)]
			#Letrero derecha
			get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/doble_signs_med/left_signs/Label3D"+str(letrero)).text = response.niveles[str(Global.numero_nivel_actual)]["intersecciones"][str(interseccion)]["seniales_med"]["izquierda"][str(letrero)]
			get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/doble_signs_med/right_signs/Label3D"+str(letrero)).text = response.niveles[str(Global.numero_nivel_actual)]["intersecciones"][str(interseccion)]["seniales_med"]["derecha"][str(letrero)]
		
	print("Me mapa se actualizo correctamente")
	
	
func _interseccion_area(body):
	if Global.habia_entrado == false:
		print("INICIAR CONTADOR DECISION")		
		tiempoInicioDecicion = Time.get_ticks_msec()
		Global.habia_entrado = true
	else:
		print("DETENER CONTADOR DECISION")
		var tiempoDecision = Time.get_ticks_msec() - tiempoInicioDecicion
		tiempoTotalDeciciones += tiempoInicioDecicion
		numDecisiones += 1
		Global.habia_entrado = false
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(http_request)
	http_request.request_completed.connect(self._carga_nivel)
	_peticion_http("https://luisanyel.000webhostapp.com/mapa.json")
	
	
	
	
	
	
	
	
	
	#await get_tree().create_timer(5).timeout 
	#_peticion_http("https://luisanyel.000webhostapp.com/test2.json")
	
	#_vista_desarrollador(1,false) #Descomentar para ver vista previa
	
	
func _peticion_http(url):
	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _process(delta):
	pass
#----------------------------UI-----------------------------
"""
#UI
enum State{
	 READY,
	 READING,
	 FINISHED,
	 INACTIVE
}

var current_state = State.INACTIVE
var text_queue = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.reiniciar:
		get_node("car").position = Vector3(10,8,0)
		Global.reiniciar = false
		
		tiempoTotal += delta
		print("Normal:" + str(Global.current_state))
		match Global.current_state:
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
					hide_textbox()
					change_state(State.FINISHED)

			State.FINISHED:
				if Input.is_action_just_pressed("ui_accept"): #Al finalizar presionar enter para quitar textbox
					#hide_textbox()
					change_state(State.READY)
					hide_textbox()	

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
		#label.text = ""
		show_textbox()
		current_char = 0
		char_timer = 0.0
		is_text_displayed = false  # Reiniciar is_text_displayed cuando se agrega nuevo texto


func change_state(next_state):
	current_state = next_state
	Global.current_state = next_state
	match current_state:
		State.READY:
			print("Cambiando estado a: State.READY")
		State.READING:
			print("Cambiando estado a: State.READING")
		State.FINISHED:
			print("Cambiando estado a: State.FINISHED")
		State.INACTIVE:
			print("Cambiando estado a: State.INACTIVE")

"""





func _vista_desarrollador(nivel,visible_):
	var json = JSON.new()
	var response
	
	var file = FileAccess.open("res://Scripts/mapa.json", FileAccess.READ)
	var content = file.get_as_text()
	json.parse(content)
	response = json.get_data()
	#print(response)
	#Cargar nombre ciudades y Vincula areas3D de las ci
	for i in range(1,13):	
		get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Letrero_aereo/Label3D").text = response.ciudades[str(i)]
		#get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Letrero_aereo/Label3D").visible = visible_
		#get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Letrero_terrestre/Label3D").text = response.ciudades[str(i)]
		#get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Letrero_terrestre/Label3D").visible = visible_
	
	for interseccion in range(1,14):	
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/nombre_interseccion").text = str(interseccion)
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/nombre_interseccion").visible = visible_
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/izquierda").text = "izquierda"
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/izquierda").visible = visible_
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/derecha").text = "derecha"
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/derecha").visible = visible_
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/medio").text = "medio"
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/medio").visible = visible_
		
