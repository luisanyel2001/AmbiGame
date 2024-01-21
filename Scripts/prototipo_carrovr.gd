extends Node3D

@onready var player: XROrigin3D = get_node("player_car/playerXR")
@onready var left_controller: XRController3D = player.get_node("left_hand")
@onready var right_controller: XRController3D = player.get_node("right_hand")
@onready var player_car: VehicleBody3D = get_node("player_car")
@onready var steering: XRToolsInteractableHinge = player_car.get_node("steering_wheel/interactable")

var init_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	#Init XR
	var interface = XRServer.find_interface("OpenXR")
	if interface and interface.initialize():
		print("OpenXR initialized successfully")
		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		# turn the main viewport into an ARVR viewport:
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
	
	#Other Init
	
	init_rotation = steering.rotate_z
	
	#Signals Init
	steering.hinge_moved.connect(_print_move)
	left_controller.input_float_changed.connect(_print_float)
	right_controller.input_float_changed.connect(_print_float2)
	left_controller.button_pressed.connect(_print_button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
	
func _input_left():
	print("Hola")
	
	
func _print_button(button):
	if button == "ax_button":
		var movement = left_controller.get_node("MovementDirect") as XRToolsMovementDirect
		var player_body = player.get_node("PlayerBody") as XRToolsPlayerBody
		movement.enabled = false
		#player_body.enabled = false
		var point = player_car.get_node("point_camera")
		#player.reparent(point, false)
		player.global_transform = point.global_transform
		print(str(button))

func _print_move(angle):
	player_car.steering = angle / 200.0
	
func _print_float(action,value):
	if action == "trigger":
		player_car.brake = clamp(value,0,100) * 100
		print("Freno: " + str(player_car.brake))
		
		
func _print_float2(action,value):
	if action == "trigger":
		player_car.engine_force = clamp(value,0,100) * 5000
		print("Acelerador: " + str(player_car.engine_force))




