extends CanvasLayer

func _ready():
	$tiempo_trans.text = Global.tiempo_transcurrido
	print(Global.tiempo_transcurrido)



func _on_reiniciar_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MapaPrincipal.tscn")


func _on_salir_button_pressed():
	get_tree().quit()
