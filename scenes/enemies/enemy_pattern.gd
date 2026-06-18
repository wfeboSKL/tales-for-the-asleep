#--VARIABLES DEL ENEMIGO CON PATRÓN--
#Se extiende a CharacterBody2D
extends CharacterBody2D
#La vida inicial
var health = 7
#Se define cuanta experiencia dará
var xp_value = 25

#El cooldown de disparo
var shoot_cooldown = 0.0
#Tiempo para el movimiento sinusoidal
var time: float = 0.0
#Referencia al jugador, inicia vacía hasta que la escena esté lista
var player = null
#Se establece el cooldown del parpadeo del sprite
var damageindicator_cooldown = 0.0
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
	
	#Si el cooldown es mayor a 0, parpadea cada 0.05 segundos
	if damageindicator_cooldown > 0:
		$Sprite2D.visible = fmod(damageindicator_cooldown, 0.2) > 0.05
	else:
		#De lo contrario, será siempre visible
		$Sprite2D.visible = true
	
	#Si sale de la pantalla, se elimina
	if position.x < -50:
		queue_free()

#-- TOMAR DAÑO --
func take_damage(amount):
	#A la vida, se le restará amount
	health -= amount
	#Se reinicia el cooldown
	damageindicator_cooldown = 1.5
	#Si la vida es menor a cero, eliminar por completo al enemigo
	if health <= 0:
		#Se suma 175 al puntaje y 1 al contador de kills
		GameData.score += 175.0
		GameData.enemies_killed += 1
		GameData.add_xp(xp_value)
		queue_free()

func _ready():
	add_to_group("Enemy")
	player = get_tree().get_first_node_in_group("Player")
	collision_layer = 2
	collision_mask = 1
