# -- VARIABLES Y CONSTANTES BASE DE TODOS LOS ENEMIGOS --
extends CharacterBody2D

# Vida por defecto (los hijos la sobrescriben si necesitan otro valor)
var health = 3
# XP que otorga al morir (los hijos la sobrescriben)
var xp_value = 99
# Cooldown de disparo, cada hijo lo resetea a su propio ritmo
var shoot_cooldown = 0.0
# Referencia al jugador
var player = null
# Cooldown del parpadeo al recibir daño
var damageindicator_cooldown = 0.0

# -- PRELOADS COMPARTIDOS --
const XP_ORB = preload("res://scenes/particles/xp_orb.tscn")

func _ready():
	add_to_group("Enemy")
	player = get_tree().get_first_node_in_group("Player")
	collision_layer = 2
	collision_mask = 1

# -- ACTUALIZAR EL PARPADEO DEL SPRITE AL RECIBIR DAÑO --
func update_damage_blink(delta):
	damageindicator_cooldown -= delta
	if damageindicator_cooldown > 0:
		$Sprite2D.visible = fmod(damageindicator_cooldown, 0.2) > 0.05
	else:
		$Sprite2D.visible = true

# -- RECIBIR DAÑO --
func take_damage(amount):
	health -= amount
	damageindicator_cooldown = 1.5
	if health <= 0:
		GameData.enemies_killed += 1
		on_death()
		queue_free()

# -- FUNCIÓN VACÍA, CADA HIJO LA SOBRESCRIBE CON SU PROPIA LÓGICA --
func on_death():
	pass
	
# -- ELIMINAR SI SALE DE LA PANTALLA --
func check_offscreen():
	if position.x < -50:
		queue_free()
