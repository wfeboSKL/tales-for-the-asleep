extends Node

# -- VARIABLES DE LA INFORMACIÓN DEL JUEGO EN GENERAL --

# Puntaje
var score = 0
# Variables que registran kills y horda actual
var enemies_killed = 0
var current_wave = 1

# -- VARIABLES DE XP Y NIVEL --
var player_xp = 0
var player_level = 1
var xp_to_next_level = 210

#Velocidad de disparo del jugador
var shoot_speed = 0.1

# -- SEÑAL DE XP --
signal xp_changed(current_xp, max_xp)
# -- SEÑAL DE SUBIDA DE NIVEL
signal level_up_occurred(new_level)

# -- FUNCIÓN PARA SUBIR DE NIVEL --
func level_up():
	player_level += 1
	player_xp = 0
	xp_to_next_level = 210 * player_level
	# Se avisa que el XP cambió tras subir de nivel
	xp_changed.emit(player_xp, xp_to_next_level)
	level_up_occurred.emit(player_level)
	# Mejorar velocidad de disparo con cada nivel, mínimo 0.05
	shoot_speed = clamp(shoot_speed - 0.005, 0.08, 0.1)

# -- AGREGAR XP AL JUGADOR --
func add_xp(amount):
	# Se suma el XP recibido
	player_xp += amount
	# Si el XP actual alcanza o supera el máximo, subir de nivel
	if player_xp >= xp_to_next_level:
		level_up()
		# Se avisa a quien escuche que el XP cambió
	xp_changed.emit(player_xp, xp_to_next_level)

# -- FUNCIÓN PARA RESETEAR LA INFORMACIÓN AL MORIR --
func reset():
	score = 0
	enemies_killed = 0
	current_wave = 1
	player_xp = 0
	player_level = 1
	xp_to_next_level = 210
	shoot_speed = 0.1
