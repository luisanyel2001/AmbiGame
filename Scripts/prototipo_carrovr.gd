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
	
	#Cargar nombre ciudades
	for i in range(1,13):	
		get_node("Ciudades/LowPolyCITY_" + str(i) + "/Letrero_aereo/Label3D").text = response.ciudades[str(i)]
		get_node("Ciudades/LowPolyCITY_" + str(i) + "/Letrero_terrestre/Label3D").text = response.ciudades[str(i)]


	
"""
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	return response
"""

