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
var xp_to_next_level = 50

# -- FUNCIÓN PARA SUBIR DE NIVEL --
func level_up():
	player_level += 1
	player_xp = 0
	xp_to_next_level = 50 * player_level

# -- FUNCIÓN PARA RESETEAR LA INFORMACIÓN AL MORIR --
func reset():
	score = 0
	enemies_killed = 0
	current_wave = 1
	player_xp = 0
	player_level = 1
	xp_to_next_level = 50
