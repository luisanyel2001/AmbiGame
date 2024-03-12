extends Node3D
@onready var target1 = get_node("../salida1")
@onready var target2 = get_node("../salida2")
@onready var target3 = get_node("../salida3")
@onready var targets = [target1, target2, target3]
var destino = 0
var salida_destino = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	destino = randi() % targets.size()
	if(destino == 0):
		salida_destino = "salida1"
	elif (destino == 1):
		salida_destino = "salida2"
	elif (destino == 2):
		salida_destino = "salida3"
	print("destino: " + salida_destino)
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
	$NavigationRegion3D/laberintoTuneles/road_tunnel/Area3D.body_entered.connect(_entro)		
	$salida1/Area3D.body_entered.connect(func(body): _entro(body, $salida1/Area3D))
	$salida2/Area3D.body_entered.connect(func(body): _entro(body, $salida2/Area3D))
	$salida3/Area3D.body_entered.connect(func(body): _entro(body, $salida3/Area3D))
			
func _entro(body, area):
	if(body == $car):		
		if(salida_destino == area.get_parent().name):
			print("Entro " + body.to_string())
			print("El objeto entró en el área: " + area.name)
			print("El nodo padre del área es: " + area.get_parent().name)

	

func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()

	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(response.glossary['title'])
	#$NavigationRegion3D/laberintoTuneles/road_tunnel/Label3D.text = response.glossary['title']
	$Label3D.text = response.glossary['title']

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

