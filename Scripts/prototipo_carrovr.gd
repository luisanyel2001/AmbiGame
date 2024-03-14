extends Node3D
# Called when the node enters the scene tree for the first time.
func _ready():	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._carga_nivel)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request("https://luisanyel.000webhostapp.com/mapa.json")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
	#_carga_nivel()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _carga_nivel(result, response_code, headers, body):
	#var peticion = _peticion_http("https://luisanyel.000webhostapp.com/mapa.json")
	#var peticion = _peticion_http("https://luisanyel.000webhostapp.com/crearUsuario.json")
	#print(peticion)
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(response)
	
	#Cargar nombre ciudades y Vincula areas3D de las ci
	for i in range(1,13):	
		get_node("Ciudades/LowPolyCITY_" + str(i) + "/Letrero_aereo/Label3D").text = response.ciudades[str(i)]
		get_node("Ciudades/LowPolyCITY_" + str(i) + "/Letrero_terrestre/Label3D").text = response.ciudades[str(i)]
		get_node("Ciudades/LowPolyCITY_" + str(i) + "/Area3D").body_entered.connect(func(body):_deteccion_area_ciudad(response.ciudades[str(i)], body))
	
	
	for i in range(1,13):	
		get_node("Ciudades/LowPolyCITY_" + str(i) + "/Letrero_aereo/Label3D").text = response.ciudades[str(i)]
		get_node("Ciudades/LowPolyCITY_" + str(i) + "/Letrero_terrestre/Label3D").text = response.ciudades[str(i)]
		get_node("Ciudades/LowPolyCITY_" + str(i) + "/Area3D").body_entered.connect(func(body):_deteccion_area_ciudad(response.ciudades[str(i)], body))
		
		
func _deteccion_area_ciudad(id, body):
	print("Se activo el area de " + id + " y entro un " + body.to_string())
	var gano: bool
	
	if id == "Sol":
		gano = true
	else:
		gano = false
		
	_carga_UI(gano)
	_carga_IA(gano)


func _carga_UI(gano):
	if gano:
		print("Ganaste")
	else:
		print("Perdiste")
		
		
func _carga_IA(gano):
	if gano:
		print("Ganaste")
	else:
		print("Perdiste")


	
"""
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	return response
"""

