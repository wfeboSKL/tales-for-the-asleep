#--VARIABLES DEL SPAWNER DE ENEMIGOS--
#Se extiende al nodo
extends Node
#Se precarga los enemigos
const ENEMY = preload("res://scenes/enemies/enemy_basic.tscn")
const ENEMYPATTERN = preload("res://scenes/enemies/enemy_pattern.tscn")
const ENEMYSENTRY = preload("res://scenes/enemies/enemy_sentry.tscn")
const ENEMYTRACK = preload("res://scenes/enemies/enemy_track.tscn")
#Variable que funciona como cooldown
var spawn_timer = 0.0
#Le dice al timer a qué número tendrá que reiniciarse una vez llegue a 0
var spawn_interval = randi_range(2,5)
#Traer los diálogos al nivel
var dialogue_box = null

#-- FUNCIÓN DE SPAWN DE ENEMIGOS --
func spawn_enemy():
	#Comportamiento según la horda actual
	match GameData.current_wave:
		1:
			#Horda 1: enemigos básicos
			spawn_basic_enemy()
		2:
			#Horda 2: enemigos con patrones
			spawn_pattern_enemy()
		3:
			#Horda 3: jefe (por ahora igual que básico)
			spawn_sentry_enemy()
		4:
			#Horda 3: jefe (por ahora igual que básico)
			spawn_track_enemy()
#-- DIVERSOS PROCESOS --
func _process(delta: float) -> void:
	if dialogue_box == null:
		dialogue_box = get_parent().get_node("DialogueBox")

	
	#Verificar en qué horda estamos según los enemigos eliminados
	if GameData.enemies_killed >= 105 and GameData.current_wave != 4:
		GameData.current_wave = 4
		dialogue_box.start_dialogue([
			["Desivinte:", "Siento que estamos haciendo buen progreso"],
			["Morthalias:", "Si..."],
			["Morthalias:", "Jaja..."],
			["Morthalias:", "Lo estás haciendo muy bien... Jaja..."],
			["Desivinte:", "¿Qué te sucede?"],
			["Morthalias:", "Solo..."],
			["Morthalias:", "Solo ignoralo."],
			["Morthalias:", "Tienes que estar listo para cuando llegue Hail the Priestess"],
			["Desivinte:", "Cada vez estamos más cerca, pero a la vez solo parecen verse más y más Helnierz"],
		])
	elif GameData.enemies_killed >= 75 and GameData.current_wave == 2:
		GameData.current_wave = 3
		dialogue_box.start_dialogue([
			["Morthalias:", "¡Buen trabajo Desivinte!"],
			["Morthalias:", "Sigue matando y verás que llegarás bastante lejos"],
			["Desivinte:", "..."],
			["Desivinte:", "Por qué no te callas de una vez..."],
			["Morthalias:", "¡Lo siento!"],
			["Morthalias:", "Solo..."],
			["Morthalias:", "Hago lo que puedo..."]
			])
	elif GameData.enemies_killed >= 40 and GameData.current_wave == 1:
		GameData.current_wave = 2
		dialogue_box.start_dialogue([
			["Morthalias:", "¡Oh no!"],
			["Morthalias:", "¡Parece que vienen enemigos más fuertes!"],
			["Morthalias:", "¡Preparate!!!!!!"],
			["Desivinte:", "..."],
			["Desivinte:", "Ugh..."]
			])
	elif GameData.current_wave == 0:
		GameData.current_wave = 1
		dialogue_box.start_dialogue([
			["Desivinte:", "Finalmente, llegamos."],
			["Morthalias:", "¡Sí!"],
			["Desivinte:", "Ahora hay que ver dónde está Hail the Priestess..."],
			["Desivinte:", "Realmente puede estar en cualquier lugar."],
			["Desivinte:", "..."],
			["Morthalias:", "¿Sucede algo?"],
			["Desivinte:", "Olvidalo."],
			["Morthalias:", "Si necesitas algo, ¡aquí estaré!"]
			])
		pass
	#Se resta delta del timer y si es menor a 0, spawnear un enemigo
	spawn_timer -= delta
	#Si timer menor que 0, spawnear un enemigo y regresar el intervalo
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = spawn_interval


#-- FUNCIÓN DE SPAWN ENEMIGOS DE BÁSICO --
func spawn_basic_enemy():
	#Número aleatorio de enemigos entre 1 y 4
	var count = randi_range(1, 5)
	#Spawnear cada enemigo con posición aleatoria
	for i in count:
		var enemy = ENEMY.instantiate()
		#Aparece fuera de la pantalla a la derecha, escalonado por i
		enemy.position.x = get_tree().root.size.x + randf_range(0, 50) + (i * 80)
		#Posición Y aleatoria dentro de los límites de la pantalla
		enemy.position.y = randf_range(70, get_tree().root.size.y - 70)
		get_parent().add_child(enemy)

#-- FUNCIÓN DE SPAWN ENEMIGOS DE PATRÓN --
func spawn_pattern_enemy():
	#Número aleatorio de enemigos entre 1 y 3
	var count = randi_range(1, 3)
	#Spawnear cada enemigo con posición aleatoria
	for i in count:
		var enemy = ENEMYPATTERN.instantiate()
		#Aparece fuera de la pantalla a la derecha, escalonado por i
		enemy.position.x = get_tree().root.size.x + randf_range(0, 50) + (i * 80)
		#Posición Y aleatoria dentro de los límites de la pantalla
		enemy.position.y = randf_range(70, get_tree().root.size.y - 70)
		get_parent().add_child(enemy)
func spawn_sentry_enemy():
	var count = randi_range(1, 2)
	for i in count:
		var enemy = ENEMYSENTRY.instantiate()
		# Posición X dentro de la pantalla (no desde la derecha, se queda fijo ahí)
		enemy.position.x = randf_range(500,1100)
		# Aparece arriba de la pantalla, fuera de vista
		enemy.position.y = 0
		get_parent().add_child(enemy)
func spawn_track_enemy():
	var count = randi_range(1, 2)
	for i in count:
		var enemy = ENEMYTRACK.instantiate()
		# Posición X dentro de la pantalla (no desde la derecha, se queda fijo ahí)
		enemy.position.x = randf_range(500,1100)
		# Aparece arriba de la pantalla, fuera de vista
		enemy.position.y = 0
		get_parent().add_child(enemy)
