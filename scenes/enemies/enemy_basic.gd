#--VARIABLES Y CONSTANTES DEL ENEMIGO --
#Se extiende a CharacterBody2D
extends "res://scripts/enemies/enemy_base.gd"
#Se define su velocidad
const SPEED = 190.0
const SPEED_Y = 110.0
const BURST_SIZE = 3
var bullets_in_burst = 0

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
		# Se dispara una bala
		var enemy_bullet = ENEMY_BULLET.instantiate()
		enemy_bullet.position = position
		get_parent().add_child(enemy_bullet)
		# Se suma una bala disparada a la ráfaga actual
		bullets_in_burst += 1
		if bullets_in_burst < BURST_SIZE:
			# Todavía faltan balas en esta ráfaga, cooldown corto
			shoot_cooldown = 0.3
		else:
			# Se completó la ráfaga, cooldown largo y se reinicia el contador
			shoot_cooldown = randf_range(1.5, 2.3)
			bullets_in_burst = 0
		
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
		get_parent().call_deferred("add_child", xp_orb)
		#Se actualiza el puntaje y la cantidad de kills
	GameData.score += 100.0
