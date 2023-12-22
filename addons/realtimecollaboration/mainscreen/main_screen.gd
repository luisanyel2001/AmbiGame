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


#Create a server 
func _create_server():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(_PORT, _MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
	_players[1] = _player_info
	player_connected.emit(1, _player_info)
	print("Servidor creado con exito en el puerto:" + str(_PORT))


#Create a client a join in a server
func _create_client(address = ""):
	if address.is_empty():
		address = _DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, _PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	print("Cliente creado con exito en el puerto:" + str(_PORT))


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
@rpc
func _update_player_transform():
	var current_scene = EditorInterface.get_edited_scene_root()
	if current_scene is Node3D:
		#Get camera position
		var position = EditorInterface.get_editor_viewport_3d(0).get_camera_3d().global_transform
		print("La ubicacion del id: " + str(multiplayer.get_remote_sender_id()) + " es: " + str(position))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
@rpc("authority", "call_local", "reliable")
func _process(delta):
	pass
	"""
	if Engine.get_process_frames() % 2 == 0:
		if Engine.is_editor_hint():
			if multiplayer.multiplayer_peer != null:
				_update_player_transform.rpc()
			#if multiplayer.is_server():
				
			#else:
				#_update_player_transform.rpc_id(multiplayer.get_remote_sender_id())
			
	"""


#------------------------------Buttons-------------------------------
func _on_btn_start_host_pressed():
	_player_info = {"nickname":$vbx_nickname/ln_nickname.text}
	_create_server()
	

func _on_btn_stop_host_pressed():
	_on_server_disconnected()


func _on_btn_join_client_pressed():
	_player_info = {"nickname":$vbx_nickname/ln_nickname.text}
	_create_client()


func _on_btn_disconnect_client_pressed():
	remove_multiplayer_peer()


func _on_btn_update_peer_list_pressed():
	if _get_players() == {}:
		$txe_peers.text = "Vacio"
	else:
		$txe_peers.text = _get_players()


func _on_btn_test_pressed():
	_update_player_transform.rpc()
