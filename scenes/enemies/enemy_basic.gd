#--VARIABLES Y CONSTANTES DEL ENEMIGO --
#Se extiende a CharacterBody2D
extends CharacterBody2D
#Se define su velocidad
const SPEED = 150.0
const SPEED_Y = 100.0
#Se establece la vida inicial (la cual cambiará por impactos)
var health = 3
#Se define cuanta experiencia dará
var xp_value = 10
#Se establece el cooldown de la bala inicial
var shoot_cooldown = 0.0
#Referencia al jugador, inicia vacía hasta que la escena esté lista
var player = null
#Se establece el cooldown del parpadeo del sprite
var damageindicator_cooldown = 0.0
#Cambios en la dirección del enemigo, un número entre aleatorio -30 y 30
var y_offset = randf_range(-90, 90)
#-- PRELOADS --
#Se "precarga" la escena de la bala enemiga
const ENEMY_BULLET = preload("res://scenes/bullets/enemy_bullet.tscn")

const XP_ORB = preload("res://scenes/particles/xp_orb.tscn")


#Función que calcula los procesos físicos cada frame
func _physics_process(delta: float) -> void:
	#--MOVIMIENTO DEL ENEMIGO--
	#Velocidad del enemigo será hacia la izquierda
	velocity.x = -SPEED
	#Si jugador existe, moverse fluidamente hacia (actual, objetivo, velocidad)
	if player:
		velocity.y = move_toward(velocity.y, clamp(player.position.y + y_offset - position.y, -SPEED_Y, SPEED_Y), SPEED_Y)
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
		#Se reestablece el cooldown aleatoriamente entre 0.9 y 1.7
		shoot_cooldown = randf_range(0.9,1.7)
		
	#-- EFECTOS VISUALES --
	#Se le resta al cooldown delta (1/fps del juego)
	damageindicator_cooldown -= delta
	#Si el cooldown es mayor a 0, parpadea cada 0.05 segundos
	if damageindicator_cooldown > 0:
		$Sprite2D.visible = fmod(damageindicator_cooldown, 0.2) > 0.05
	else:
		#De lo contrario, será siempre visible
		$Sprite2D.visible = true
	#Si la posición del enemigo es -50 fuera de la pantalla, eliminarlo por completo
	if position.x< -50:
		queue_free()

#-- RECIBIR EL DAÑO --
#Amount es lo que se definió que la bala haría de daño en la escena de bala
func take_damage(amount):
	#A la vida, se le restará amount
	health -= amount
	#Se reinicia el cooldown
	damageindicator_cooldown = 1.5
	#Si la vida es menor a cero, eliminar por completo al enemigo
	if health <= 0:
		var count = 5
		for i in count:
			var xp_orb = XP_ORB.instantiate()
			xp_orb.position = position
			get_parent().add_child(xp_orb)
		#Se actualiza el puntaje y la cantidad de kills
		GameData.score += 100.0
		GameData.enemies_killed += 1
		queue_free()

#-- OBTENER PLAYER --
#Obtener el primer nodo del grupo "player" para seguirlo
func _ready():
	#Se añade al grupo "Enemy"
	add_to_group("Enemy")
	#Se busca al grupo Player
	player = get_tree().get_first_node_in_group("Player")
	#Se establece el Layer y el Mask
	collision_layer = 2
	collision_mask = 1
	
