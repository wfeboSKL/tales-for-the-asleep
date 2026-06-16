#-- VARIABLES DE LA INFORMACIÓN DEL JUEGO EN GENERAL --
extends Node
#Puntaje
var score = 0
#Variables que registran kills y horda actual
var enemies_killed = 0
var current_wave = 1

#-- FUNCIÓN PARA RESETEAR LA INFORMACIÓN UNA VEZ QUE SE OCUPE --
#Cuando el jugador muera básicamente
func reset():
	score = 0
	enemies_killed = 0
	current_wave = 1
