@tool #Descomentar para ver vista previa
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	_vista_desarrollador(1,true) #Descomentar para ver vista previa
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _vista_desarrollador(nivel,visible_):
	var json = JSON.new()
	var response
	
	print("Leido por local")
	var file = FileAccess.open("res://Scripts/mapa.json", FileAccess.READ)
	var content = file.get_as_text()
	json.parse(content)
	response = json.get_data()
	#print(response)
	#Cargar nombre ciudades y Vincula areas3D de las ci
	for i in range(1,13):	
		get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Letrero_aereo/Label3D").text = response.ciudades[str(i)]
		get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Letrero_aereo/Label3D").visible = visible_
		get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Letrero_terrestre/Label3D").text = response.ciudades[str(i)]
		get_node("Ciudades/Ciudad_" + str(i) + "/LowPolyCITY/Letrero_terrestre/Label3D").visible = visible_

	
	for interseccion in range(1,14):	
		print(interseccion)
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/nombre_interseccion").text = str(interseccion)
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/nombre_interseccion").visible = visible_
		
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/izquierda").text = "izquierda"
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/izquierda").visible = visible_
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/derecha").text = "derecha"
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/derecha").visible = visible_
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/medio").text = "medio"
		get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/medio").visible = visible_
		
		"""
		#Recorre los letreros
		for letrero in range(1,4):
			#get_node("Tuneles/intersection_tunnel"+str(interseccion)+"/izquierda").text = response.niveles[str(nivel)]["intersecciones"][str(interseccion)]["seniales"]["izquierda"][str(letrero)]
		"""	
