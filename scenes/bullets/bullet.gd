#-- VARIABLES INICIALES DE LA BALA --
#Conectar Script con Area2D
extends Area2D
#Establecer velocidad de la bala
const SPEED = 1050.0
#-- MOVIMIENTO DE LA BALA --
#Función que procesa cada frame la bala
func _process(delta: float) -> void:
	#Dirección en X de la bala
	position.x += SPEED*delta
	if position.x > get_viewport_rect().size.x:
		queue_free()

#-- CONTACTO DE BALA CON ENEMIGO --
#Función que indica cuando la bala entra en un objeto
#Body se refiere a dicho objeto que este toca
func _on_body_entered(body):
	print("Cuerpo detectado: ", body.name, " Grupos: ", body.get_groups())
	#Si el cuerpo que toca está en el grupo "Enemy"
	if body.is_in_group("Enemy"):
		#Tomará 1 de daño
		body.take_damage(1)
		#Luego la bala se eliminará
		queue_free()
