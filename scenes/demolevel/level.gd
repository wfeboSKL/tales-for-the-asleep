#Se extiende a Node2D
extends Node2D

#-- FUNCIÓN DE PROCESO --
func _process(delta: float) -> void:
	#Movimiento hacia la izquierda del fondo
	$ParallaxBackground.scroll_offset.x -= 60 * delta
	#Movimiento hacia la izquierda del fondo
	$ParallaxBackground/ParallaxLayer3.motion_offset.x -= 70 * delta
