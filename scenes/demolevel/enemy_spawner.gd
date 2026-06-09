#--VARIABLES DEL SPAWNER DE ENEMIGOS--
#Se extiende al nodo
extends Node
#Se precarga los enemigos
const ENEMY = preload("res://scenes/enemies/enemy.tscn")
const ENEMYPATTERN = preload("res://scenes/enemies/enemy_pattern.tscn")
#Variable que funciona como cooldown
var spawn_timer = 0.0
#Le dice al timer a qué número tendrá que reiniciarse una vez llegue a 0
var spawn_interval = 2.0
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
			spawn_basic_enemy()

#-- DIVERSOS PROCESOS --
func _process(delta: float) -> void:
	if dialogue_box == null:
		dialogue_box = get_parent().get_node("DialogueBox")

	
	#Verificar en qué horda estamos según los enemigos eliminados
	#Si se matan más de 40 enemigos y no es la horda 3, ahora es la horda 3
	if GameData.enemies_killed >= 40 and GameData.current_wave != 3:
		GameData.current_wave = 3
		dialogue_box.start_dialogue([
			["Morthalias:", "Good Job Desivinte! You're kicking ass out there!"],
			["Desivinte:", "..."],
			["Desivinte:", "You should shut up already..."]
			])
	#Si se matan más de 20 enemigos y es la horda 1, ahora es la horda 2
	elif GameData.enemies_killed >= 20 and GameData.current_wave == 1:
		GameData.current_wave = 2
		dialogue_box.start_dialogue([
			["Morthalias:", "Oh no, a new wave of enemies!"],
			["Morthalias:", "Incoming!!!!!"],
			["Desivinte:", "..."],
			["Desivinte:", "Sigh..."]
			])
	#Se resta delta del timer y si es menor a 0, spawnear un enemigo
	spawn_timer -= delta
	#Si timer menor que 0, spawnear un enemigo y regresar el intervalo
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = spawn_interval


#-- FUNCIÓN DE SPAWN ENEMIGOS DE BÁSICO --
func spawn_basic_enemy():
	#Número aleatorio de enemigos entre 1 y 4
	var count = randi_range(1, 4)
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
