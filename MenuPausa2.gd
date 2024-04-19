extends Control



var is_paused: bool = false

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused


func set_is_paused(value:bool) -> void:
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _on_reanudar_button_pressed():
	self.is_paused = false
	$".".hide()
	

func _on_salir_button_pressed():
	var end_scene = preload("res://UI/GameOver.tscn")
	get_tree().change_scene_to_packed(end_scene)
	#get_tree().quit()


func _on_reiniciar_button_pressed():
	pass
	#get_tree().change_scene_to_file("res://Scenes/prototipo_carro_2vr.tscn")
	#get_tree().change_scene_to_file("res://Scenes/MapaPrincipal.tscn")
