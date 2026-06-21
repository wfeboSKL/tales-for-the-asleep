extends "res://scripts/enemies/enemy_base.gd"

var in_home = false
var is_shooting = false
var home_position = Vector2.ZERO
var move_direction = -1
var movement_cooldown = 0.0
var shoot_pause = 0.0
var target_y = 0.0
var directions = [-1, 1]
const SPEED = -70.0
const SPEED_Y = 230.0
#Se "precarga" la escena de la bala enemiga
const ENEMY_TRACK_BULLET = preload("res://scenes/bullets/enemy_track_bullet.tscn")


func _physics_process(delta: float) -> void:
	if not in_home:
		# Todavía no llegó, sigue cayendo
		velocity.y = move_toward(velocity.y, home_position.y, SPEED_Y * delta)
		velocity.x = move_toward(velocity.x, home_position.x, SPEED * delta)
		if abs(position.y - home_position.y) < 5.0:
			in_home = true
			target_y = randf_range(10, 225)
	else:
		position.y = clamp(position.y, home_position.y - 225, home_position.y + 225)
		# Ya está en home, oscila para siempre (sin volver a chequear distancia)
		if is_shooting:
			shoot_pause -= delta
			velocity.y = 0
			velocity.x = move_toward(velocity.x, home_position.x, SPEED * delta)
			if shoot_pause <= 0:
				is_shooting = false
				move_direction = directions.pick_random()
				movement_cooldown = 1.7
				target_y = randf_range(10, 225)
		else:
			movement_cooldown -= delta
			velocity.y = move_toward(velocity.y, target_y, SPEED_Y)
			velocity.x = move_toward(velocity.x, home_position.x, SPEED * delta)
			if movement_cooldown <= 0:
				is_shooting = true
				shoot_pause = 1.3
				var enemy_bullet = ENEMY_TRACK_BULLET.instantiate()
				enemy_bullet.position = position
				get_parent().add_child(enemy_bullet)
				shoot_cooldown = 5.0
	move_and_slide()
	#-- EFECTOS VISUALES --
	update_damage_blink(delta)

func _ready():
	super()
	health = 7
	xp_value = 55
	home_position = Vector2(position.x-200, 300)

func on_death():
	var count = 17
	for i in count:
		var xp_orb = XP_ORB.instantiate()
		xp_orb.position = position
		get_parent().call_deferred("add_child", xp_orb)
		#Se suma 175 al puntaje
	GameData.score += 270.0
