#-- VARIABLES INICIALES DE LA BALA --
#Conectar Script con Area2D
extends Area2D
#Establecer velocidad de la bala
const SPEED = 1050.0
#-- MOVIMIENTO DE LA BALA
#Función que procesa cada frame la bala
func _process(delta: float) -> void:
	#Dirección en X de la bala
	position.x += SPEED*delta
	if position.x > get_viewport_rect().size.x:
		queue_free()
func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(1)
		queue_free()
