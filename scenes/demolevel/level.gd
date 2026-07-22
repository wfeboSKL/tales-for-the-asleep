#Se extiende a Node2D
extends Node2D

#-- FUNCIÓN DE PROCESO --
func _process(delta: float) -> void:
	#Movimiento hacia la izquierda del fondo
	$ParallaxBackground.scroll_offset.x -= 60 * delta
	#Movimiento hacia la izquierda del fondo
	$ParallaxBackground/ParallaxLayer3.motion_offset.x -= 70 * delta

# Ruta a la escena del menú de pausa
const PAUSE_MENU = preload("res://pause_menu.tscn")

var pause_menu_instance = null

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC por defecto
		if get_tree().paused:
			_resume()
		else:
			_pause()

func _pause():
	get_tree().paused = true
	pause_menu_instance = PAUSE_MENU.instantiate()
	add_child(pause_menu_instance)

func _resume():
	get_tree().paused = false
	if pause_menu_instance:
		pause_menu_instance.queue_free()
		pause_menu_instance = null
