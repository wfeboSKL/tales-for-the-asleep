#-- VARIABLES INICIALES DEL MELEE --
#Conectar Script con Area2D
extends Area2D

#Variable que funciona como cooldown
var melee_cooldown = 0.0

const DURATION = 0.25
#Se asegura que al inicio, el cooldown sea de 0.15
func _ready():
	melee_cooldown = DURATION

func _process(delta: float) -> void:
	#Se le resta delta al timer cada frame
	melee_cooldown -= delta
	#Si el timer llega a 0, reiniciar el timer
	if melee_cooldown <= 0:
		queue_free()


#-- CONTACTO DE PUÑO CON ENEMIGO --
#Función que indica cuando el puño entra en un objeto
func _on_body_entered(body):
	#Si el cuerpo que toca está en el grupo "Enemy"
	if body.is_in_group("Enemy"):
		#Tomará 1 de daño
		body.take_damage(5)
		#Luego la bala se eliminará
		queue_free()
