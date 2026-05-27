#-- VARIABLES INICIALES DE BALA ENEMIGA
#Conectar con Area2D
extends Area2D
#Establecer velocidad en 250.0
const SPEED = 250.0
#Variable guardará dirección de la bala
var direction = Vector2.DOWN
#Función que procesa cada frame
func _process(delta: float) -> void:
	#Posición se actualizará en positivo junto a la dirección, la velocidad y delta
	position += direction*SPEED*delta

#Cuando sale de la pantalla se eliminará
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
