# -- VARIABLES Y CONSTANTES DEL ORBE DE XP --
extends Area2D

# Velocidad base de persecución hacia el jugador
const SPEED = 500.0
# Velocidad cuando está muy cerca del jugador (entra más rápido, sin orbitar)
const SPEED_CLOSE = 200.0
# Referencia al jugador
var player = null
# XP que otorga al ser recolectado, con pequeña variación aleatoria
var xp_orb_value = randf_range(0.9, 1.1)*2


# -- VARIABLES DE LA EXPLOSIÓN INICIAL --
# Dirección aleatoria del "salto" al nacer
var explosion_direction = Vector2.ZERO
# Qué tan fuerte es el salto; baja a 0 con el tiempo
var explosion_strength = 3.5

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	collision_layer = 2
	collision_mask = 1
	
	# Se calcula una dirección aleatoria para el salto inicial (cualquier punto del círculo)
	var angle = randf_range(0, TAU)
	explosion_direction = Vector2(cos(angle), sin(angle))
	
	# Se conecta la señal de colisión con el jugador
	self.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if player:
		# La fuerza de la explosión se apaga gradualmente con el tiempo
		explosion_strength = move_toward(explosion_strength, 0.0, delta * 2.0)
		# El objetivo combina la posición del jugador con el offset de explosión
		var target = player.position + (explosion_direction * 40 * explosion_strength)
		# Si está muy cerca del jugador, acelera para entrar derecho sin orbitar
		var distance = position.distance_to(player.position)
		var current_speed = SPEED_CLOSE if distance < 60 else SPEED
		position = position.move_toward(target, current_speed * delta)

func _on_body_entered(body):
	# Si quien toca el orbe es el jugador, se le otorga el XP y el orbe desaparece
	if body.is_in_group("Player"):
		GameData.add_xp(xp_orb_value)
		queue_free()
