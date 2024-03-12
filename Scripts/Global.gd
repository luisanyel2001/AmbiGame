extends Node

var cronometro_scene = preload("../UI/cronometro.tscn")
var cronometro = null 

func _ready():
	cronometro = cronometro_scene.instantiate()
	get_tree().root.add_child(cronometro)


