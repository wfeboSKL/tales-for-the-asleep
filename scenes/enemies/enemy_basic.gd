#--VARIABLES Y CONSTANTES DEL ENEMIGO --
#Se extiende a CharacterBody2D
extends "res://scripts/enemies/enemy_base.gd"
#Se define su velocidad
const SPEED = 150.0
const SPEED_Y = 100.0

#Cambios en la dirección del enemigo, un número entre aleatorio -30 y 30
var y_offset = randf_range(-90, 90)
#-- PRELOADS --
#Se "precarga" la escena de la bala enemiga
const ENEMY_BULLET = preload("res://scenes/bullets/enemy_bullet.tscn")

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
	update_damage_blink(delta)
	check_offscreen()

#-- RECIBIR EL DAÑO --
#Amount es lo que se definió que la bala haría de daño en la escena de bala
func on_death():
	var count = 5
	for i in count:
		var xp_orb = XP_ORB.instantiate()
		xp_orb.position = position
		get_parent().add_child(xp_orb)
		#Se actualiza el puntaje y la cantidad de kills
	GameData.score += 100.0
