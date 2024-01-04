extends Node3D

var xr_interface: XRInterface

#enum GameState {IDLE, RUNNING, ENDED}  #pruebas para diferentes señales de juego
#var game_state

#@onready var ui = $"../ui" as ui 

func _ready():
	#game_state = GameState.IDLE
	#ui.game_started.connect(game_started)
	
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
		
#func game_started():
	#game_state = GameState.RUNNING
	


	
