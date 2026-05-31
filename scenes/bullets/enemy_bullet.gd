#--VARIABLES DE LA BALA ENEMIGA--
#Se extiende a AREA2D
extends Area2D
#Se define la velocidad de la bala enemiga
const SPEED = 400.0

#Función que realiza procesos cada frame
func _process(delta: float) -> void:
	#Dirección en X de la bala, derecha a izquierda
	position.x -= SPEED*delta
	#Si la posición de la bala es menor a 0 (origen de la pantalla), se elimina
	if position.x < 0:
		queue_free()
#-- CONTACTO DE BALA CON EL JUGADOR --
#Función que indica cuando la bala entra en un objeto
#Body se refiere a dicho objeto que este toca, en este caso el jugador
func _on_body_entered(body):
	#Si el cuerpo que toca está en el grupo "Player" tomará 1 de daño y se eliminará
	if body.is_in_group("Player"):
		body.take_damage(10)
		queue_free()
