@tool
extends Control

# These custom signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

#Attributes
var _DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
var _PORT = 135
var _MAX_CONNECTIONS = 20

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var _players = {}

# This is the local player info.
var _player_info = {}

#Count of players
var _players_loaded = 0

var real = false

var _global_scene = EditorInterface.get_edited_scene_root() #Cambiar por export en UI
	
#Is called when the node and its children 
#have all added to the scene tree and are ready
func _ready():
	#Init. Links to calls
	multiplayer.multiplayer_peer = null
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	
	var scene = EditorInterface.get_edited_scene_root()
	print("carga: " + scene.scene_file_path.get_file())
	
	



#Create a server 
func _create_server():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(_PORT, _MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
	_players[1] = _player_info
	player_connected.emit(1, _player_info)
	print("Servidor creado con exito en el puerto:" + str(_PORT) + " en la direccion: " + str(IP.get_local_addresses()) )


#Create a client a join in a server
func _create_client(address = ""):
	if address.is_empty():
		address = _DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, _PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	print("Cliente creado con exito en el puerto:" + str(_PORT) + " en la direccion:" + str(address))


func _set_player_info(nickname):
	_player_info = {"nickname": nickname}


func _get_players():
	return _players
	

# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)


# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		_players_loaded += 1
		if _players_loaded == _players.size():
			$/root/Game.start_game()
			_players_loaded = 0
	
	
# When a peer connects, send them my player info.
func _on_player_connected(id):
	_register_player.rpc_id(id, _player_info)
	
	
# Call local is required if the server is also a player.
@rpc("any_peer", "call_local", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	_players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	print("Usuario creado con el id:" + str(new_player_id))


func _on_player_disconnected(id):
	_players.erase(id)
	player_disconnected.emit(id)
	print("Jugador desconectado")


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	_players[peer_id] = _player_info
	player_connected.emit(peer_id, _player_info)
	print("Conexion exitosa")


func _on_connected_fail():
	multiplayer.multiplayer_peer = null
	print("Conexion fallida")


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null
	print("Remueve peer")
	

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	_players.clear()
	server_disconnected.emit()
	print("Server desconectado")


# Call local is required if the server is also a player.
@rpc("any_peer", "call_local", "reliable")
func _update_player_transform():
	var current_scene = EditorInterface.get_edited_scene_root()
	if current_scene is Node3D:
		#Get camera position
		var position = EditorInterface.get_editor_viewport_3d(0).get_camera_3d().global_transform
		print("La ubicacion del id: " + str(multiplayer.get_remote_sender_id()) + " es: " + str(position))
	
	
# Call local is required if the server is also a player.
@rpc("any_peer", "call_local", "reliable")
func _get_scene_transform():
	print("Entro escena get")
	var current_scene_root = EditorInterface.get_edited_scene_root()
	print("Escena:" + current_scene_root.to_string())
	if current_scene_root is Node3D:
		transverse_scene(current_scene_root)


func transverse_scene(node):
	if node is Node3D:
		print("Nombre a buscar: " + node.name)
		var se = _global_scene.find_child(node.name)
		if se != null:
			print("Encuentra")
			
		print(se)
	# Transverse chiilds
	for i in range(node.get_child_count()):
		transverse_scene(node.get_child(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
@rpc("any_peer", "call_local", "reliable")
func _process(delta):
	#Reducir a cada dos frames
	if Engine.get_process_frames() % 100 == 0:
		if real == true:
			if Engine.is_editor_hint():
				if multiplayer.multiplayer_peer != null:
					_update_player_transform.rpc()
				
				#Otro codigo
				#_get_scene_transform()
		
			
			
func _test():
	print("Cambio")

#------------------------------Buttons-------------------------------
func _on_btn_start_host_pressed():
	_player_info = {"nickname":$vbx_nickname/ln_nickname.text}
	_create_server()
	# Get automatically host scene. Try to create select export scene in gui
	_global_scene = EditorInterface.get_edited_scene_root()
	

func _on_btn_stop_host_pressed():
	_on_server_disconnected()


func _on_btn_join_client_pressed():
	_player_info = {"nickname":$vbx_nickname/ln_nickname.text}
	print($ln_client_ip.text)
	_create_client($ln_client_ip.text)


func _on_btn_disconnect_client_pressed():
	remove_multiplayer_peer()


func _on_btn_update_peer_list_pressed():
	if _get_players() == {}:
		$txe_peers.text = "Vacio"
	else:
		$txe_peers.text = _get_players()


func _on_btn_test_pressed():
	if real == false:
		real = true
	else:
		real = false
	#_update_player_transform.rpc()
	



@rpc("any_peer", "call_local", "reliable")
func _mandar_datos(value = "Nada"):
	print("El id: " + str(multiplayer.get_remote_sender_id()) + " envio: " + str(value))
	
	
@rpc("any_peer", "call_local", "reliable")
func _mover_cuadro(value):
	#Que envio
	print("El id: " + str(multiplayer.get_remote_sender_id()) + " envio: " + str(value))
	#Actualiza movimiento a todos	
	var current_scene_root = EditorInterface.get_edited_scene_root()
	if current_scene_root != null: 
		var busqueda = current_scene_root.find_child("Floor") as Node3D
		if busqueda != null:
			print(busqueda)
			print(busqueda.position)
			busqueda.position = value
			print("Moviento exitoso")
			


@rpc("any_peer", "call_local", "reliable")
func _actualizar_nodo(value):
	#Que envio
	print("El id: " + str(multiplayer.get_remote_sender_id()) + " envio: " + str(value))
	#Actualiza movimiento a todos	
	var current_scene_root = EditorInterface.get_edited_scene_root()
	if current_scene_root != null: 
		var busqueda = current_scene_root.find_child("Floor") as Node3D
		if busqueda != null:
			busqueda = value
			print("Moviento exitoso")



func _on_btn_test_2_pressed():
	var current_scene_root = EditorInterface.get_edited_scene_root()
	var nodo_envio = current_scene_root.find_child("Floor")
	_actualizar_nodo.rpc(nodo_envio)
	#var posicion_local = current_scene_root.find_child("Floor").position
	#_mover_cuadro.rpc(posicion_local)
	#_mandar_datos.rpc(str(EditorInterface.get_editor_viewport_3d(0).get_camera_3d().global_transform))
	#_mover_cuadro().rpc()
	#_update_player_transform.rpc()
	#print(_global_scene)
	#_get_scene_transform()
	


		

	
#Obtiene objetos seleccionados	
#print(EditorInterface.get_selection().get_selected_nodes())