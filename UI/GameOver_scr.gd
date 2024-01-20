extends CanvasLayer


func _on_reiniciar_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MapaPrincipal.tscn")


func _on_salir_button_pressed():
	get_tree().quit()
