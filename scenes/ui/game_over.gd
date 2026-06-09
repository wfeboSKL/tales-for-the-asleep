#--MOSTRAR PANTALLA GAME OVER--
#Se extiende a toda esta escena
extends CanvasLayer

#-- FUNCIÓN _READY PARA EL INICIO DE CADA RUN --
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	#Cuando se crea, "get_tree" (a.k.a todo el juego) se detiene
	get_tree().paused = true
#-- FUNCIÓN DE REGISTRAR UNA TECLA --
func _input(event):
	#Si evento es "presión de tecla" y el evento es "presionado" y la tecla es "enter"
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		get_tree().paused = false
		get_tree().reload_current_scene()
