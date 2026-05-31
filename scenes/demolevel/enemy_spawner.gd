#--VARIABLES DEL SPAWNER DE ENEMIGOS--
#Se extiende al nodo
extends Node
#Se precarga los enemigos
const ENEMY = preload("res://scenes/enemies/enemy.tscn")
#Variable que funciona como cooldown
var spawn_timer = 0.0
#Le dice al timer a qué número tendrá que reiniciarse una vez llegue a 0
var spawn_interval = 2.0

func _process(delta: float) -> void:
	#Se le resta delta al timer cada frame
	spawn_timer -= delta
	#Si el timer llega a 0, spawnear enemigos y reiniciar el timer
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = spawn_interval
		
func spawn_enemy():
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
