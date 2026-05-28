#--VARIABLES DEL ENEMIGO --
#Se extiende a CharacterBody2D
extends CharacterBody2D
#Se define su velocidad
const SPEED = 150.0
#Se establece la vida inicial (la cual cambiará por impactos)
var health = 3
#Se establece el cooldown de la bala inicial
var shoot_cooldown = 0.0
#Se "precarga" la escena de la bala enemiga
const ENEMY_BULLET = preload("res://scenes/bullets/enemy_bullet.tscn")

#--MOVIMIENTO DEL ENEMIGO--
#Función que calcula los procesos físicos cada frame
func _physics_process(delta: float) -> void:
	#Velocidad del enemigo será hacia la izquierda
	velocity.x = -SPEED
	#Se hace el cálculo final del movimiento
	move_and_slide()
	
	#--DISPARO DEL ENEMIGO--
	#Se le resta al cooldown delta (1/fps del juego)
	shoot_cooldown -= delta
	#Si el cooldown es menor o igual a 0
	if shoot_cooldown <= 0:
		#La variable bala crea (o instancia) la escena ENEMY_BULLET
		var enemy_bullet = ENEMY_BULLET.instantiate()
		#La bala iniciará a partir de la posición del enemigo
		enemy_bullet.position = position
		#Se crea la bala como un nodo hijo del enemigo
		get_parent().add_child(enemy_bullet)
		#Se reestablece el cooldown a 0.9
		shoot_cooldown = 0.9
	
	#Si la posición del enemigo es -50 fuera de la pantalla, eliminarlo por completo
	if position.x< -50:
		queue_free()
#Se hace el cálculo de daño tomado (enviado por una señal) con la función take_damage con el parámetro "amount"
#Amount es lo que se definió que la bala haría de daño en la escena de bala
func take_damage(amount):
	#A la vida, se le restará amount
	health -= amount
	#Si la vida es menor a cero, eliminar por completo al enemigo
	if health <= 0:
		queue_free()
	
