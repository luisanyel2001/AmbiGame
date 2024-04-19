"""
extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State{
	 READY,
	 READING,
	 FINISHED
}

var current_state = State.READY
var text_queue = []

#animacion letras
var current_text = ""
var current_char = 0
var char_timer = 0.0
var is_text_displayed = false 

func _ready():
	print("Iniciando: State.READY")
	hide_textbox()
	queue_text("Haz llegado a tu Destino! Ahora dirigete hacia ...")
	queue_text("Continua yendo hacia ... ")
	queue_text("Textooooo treees")
	
func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	current_text = next_text
	change_state(State.READING)
	label.text = ""
	show_textbox()
	current_char = 0
	char_timer = 0.0
	is_text_displayed = false  # Reiniciar is_text_displayed cuando se agrega nuevo texto

func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if not is_text_displayed and current_char < current_text.length():
				char_timer += delta
				if char_timer > CHAR_READ_RATE:
					label.text += current_text[current_char]
					current_char += 1
					char_timer = 0.0
			else:
				# Detener el proceso cuando se haya mostrado todo el texto
				is_text_displayed = true  # Se ha mostrado todo el texto
				change_state(State.FINISHED)

		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"): #Al finalizar presionar enter para quitar textbox
				change_state(State.READY)
				hide_textbox()


func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Cambiando estado a: State.READY")
		State.READING:
			print("Cambiando estado a: State.READING")
		State.FINISHED:
			print("Cambiando estado a: State.FINISHED")
"""



extends CanvasLayer

var gano = false	
var perdio = false

func _ready():
	change_state(State.READY)
	print("Iniciando: State.READY")
	mostrar_texto_inicio()
	_carga_UI(gano)

func _carga_UI(gano):
	if gano:
		queue_text("Muy bien, ahora dirígete hacia : " + objetivo_nivel + "        ")
		# Obtener el primer mensaje en la cola
		var next_text = text_queue.pop_front()
		
		# Agregar el mensaje de nuevo al final de la cola para iniciar el ciclo
		text_queue.push_back(next_text)
		
		# Mostrar el primer mensaje en la cola
		queue_text(next_text)
		display_text()
		change_state(State.READY)
		gano = false
	
	if perdio:
		queue_text("Lo siento, has perdido. Tu destino era: " + objetivo_nivel + "        ")
		var next_text = text_queue.pop_front()
		
		# Agregar el mensaje de nuevo al final de la cola para iniciar el ciclo
		text_queue.push_back(next_text)
		
		# Mostrar el primer mensaje en la cola
		queue_text(next_text)
		display_text()
		change_state(State.READY)
		perdio = false
		
const CHAR_READ_RATE = 0.2

@onready var textbox_container = $Textbox/TextboxContainer
@onready var start_symbol = $Textbox/TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $Textbox/TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $Textbox/TextboxContainer/MarginContainer/HBoxContainer/Label

enum State{
	 READY,
	 READING,
	 FINISHED,
	 INACTIVE
}

var current_state = State.READY
var text_queue = []

#animacion letras
var current_text = ""
var current_char = 0
var char_timer = 0.0
var is_text_displayed = false 
var objetivo_nivel

func mostrar_texto_inicio():
	queue_text("Bienvenido. Tu primer objetivo es: " + objetivo_nivel +"     ")
	# Obtener el primer mensaje en la cola
	var next_text = text_queue.pop_front()
	# Agregar el mensaje de nuevo al final de la cola para iniciar el ciclo
	text_queue.push_back(next_text)
	
	# Mostrar el primer mensaje en la cola
	queue_text(next_text)
	display_text()
	change_state(State.READY)

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	#if current_state == State.READY:
		var next_text = text_queue.pop_front()
		current_text = next_text
		change_state(State.READING)
		#label.text = ""
		show_textbox()
		current_char = 0
		char_timer = 0.0
		is_text_displayed = false  # Reiniciar is_text_displayed cuando se agrega nuevo texto


func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Cambiando estado a: State.READY")
		State.READING:
			print("Cambiando estado a: State.READING")
		State.FINISHED:
			print("Cambiando estado a: State.FINISHED")
		State.INACTIVE:
			print("Cambiando estado a: State.INACTIVE")
			
			
func _process(delta):
		match current_state:
			State.INACTIVE:
				pass
			State.READY:
				if !text_queue.is_empty():
					display_text()
			State.READING:
				if not is_text_displayed and current_char < current_text.length():
					char_timer += delta
					if char_timer > CHAR_READ_RATE:
						label.text += current_text[current_char]
						current_char += 1
						char_timer = 0.0
				else:
					# Detener el proceso cuando se haya mostrado todo el texto
					is_text_displayed = true  # Se ha mostrado todo el texto
					hide_textbox()
					change_state(State.FINISHED)

			State.FINISHED:
				if Input.is_action_just_pressed("ui_accept"): #Al finalizar presionar enter para quitar textbox
					#hide_textbox()
					change_state(State.READY)
					hide_textbox()	
