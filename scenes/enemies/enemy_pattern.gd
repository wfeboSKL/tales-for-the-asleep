#--VARIABLES DEL ENEMIGO CON PATRÓN--
#Se extiende a CharacterBody2D
extends "res://scripts/enemies/enemy_base.gd"

#Tiempo para el movimiento sinusoidal
var time: float = 0.0

#Pre-cargar balas
const ENEMY_BULLET = preload("res://scenes/bullets/enemy_bullet.tscn")

#-- EXPORTAR VARIABLES PARA MOVIMIENTO ONDULATORIO --
#Se define su velocidad
@export var speed: float = 200.0
#Se define su movimiento en x
@export var frequency: float = 5.0
#Se define su movimiento en y
@export var amplitude: float = 150.0

#-- ESTABLECER FUNCIONES DE PATRONES DE DISPARO --
func shoot_pattern():
	#Cantidad de balas, ángulo de extensión y cambios entre los ángulos
	var num_bullets = 5
	var spread_angle = 45.0
	var base_angle = sin(time * 2.0) * 45.0
	
	#Cálculos de la posición exacta de la bala
	for i in num_bullets:
		var angle = base_angle + (i - num_bullets / 2.0) * (spread_angle / num_bullets)
		#Se instancia la bala
		var bullet = ENEMY_BULLET.instantiate()
		bullet.position = position
		bullet.rotation = deg_to_rad(angle)
		get_parent().add_child(bullet)

#-- DIVERSOS PROCESOS --
func _physics_process(delta: float) -> void:
	#Tiempo acelera con delta
	time += delta
	#Indicador de daño (su cooldown) y el cooldown de disparo disminuyen con delta
	damageindicator_cooldown -= delta
	shoot_cooldown -= delta
	#Si el cooldown es menor o igual a 0, instanciar una bala y el cooldown cambia entre [1.5-2.5]
	if shoot_cooldown <= 0:
		shoot_pattern()
		shoot_cooldown = randf_range(1.5, 2.5)
	
	# Offset del movimiento ondulatorio en X (debido a que el tiempo aumenta, progresará a la izquierda)
	var wave_offset = sin(time * frequency) * amplitude
	
	# Movimiento oscilante en Y
	velocity.x = -speed
	velocity.y = wave_offset
	# Calculo de movimiento final
	move_and_slide()
	
	#-- EFECTOS VISUALES --
	update_damage_blink(delta)
	check_offscreen()
	
#-- TOMAR DAÑO --
func on_death():
	var count = 7
	for i in count:
		var xp_orb = XP_ORB.instantiate()
		xp_orb.position = position
		get_parent().call_deferred("add_child", xp_orb)
		#Se suma 175 al puntaje
	GameData.score += 175.0
	
func _ready():
	super()  # ejecuta primero el _ready() del padre (busca jugador, etc.)
	health = 7
	xp_value = 25
