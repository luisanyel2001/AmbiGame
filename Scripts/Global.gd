extends Node

#var cronometro_scene = preload("../UI/cronometro.tscn")
#var cronometro = null 

var objetivo_nivel : String
var current_state = State.INACTIVE

enum State{
	 READY,
	 READING,
	 FINISHED,
	 INACTIVE
}

var gano = false	
var perdio = false

func _ready():
	pass
	#cronometro = cronometro_scene.instantiate()
	#get_tree().root.add_child(cronometro)


