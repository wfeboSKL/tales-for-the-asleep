extends "res://scripts/enemies/enemy_base.gd"

var in_home = false
var is_shooting = false
var home_position = Vector2.ZERO
var move_direction = -1
var movement_cooldown = 0.0
var shoot_pause = 0.0
const SPEED = -70.0
const SPEED_Y = 220.0
#Se "precarga" la escena de la bala enemiga
const ENEMY_BULLET = preload("res://scenes/bullets/enemy_bullet.tscn")

func shoot_pattern():
	var num_bullets = 3
	var angle_to_player = position.angle_to_point(player.position) + PI
	# Vector perpendicular a la dirección de disparo, para separar las balas
	var perpendicular = Vector2(-sin(angle_to_player), cos(angle_to_player))
	
	for i in num_bullets:
		var bullet = ENEMY_BULLET.instantiate()
		# Offset lateral: -1, 0, 1 multiplicado por espaciado, para separar las 3 balas
		var offset = (i - 1) * 15
		bullet.position = position + perpendicular * offset
		bullet.rotation = angle_to_player
		get_parent().add_child(bullet)

func _physics_process(delta: float) -> void:
	if not in_home:
		# Todavía no llegó, sigue cayendo
		velocity.y = move_toward(velocity.y, home_position.y, SPEED_Y * delta)
		if position.distance_to(home_position) < 5:
			in_home = true
	else:
		position.y = clamp(position.y, home_position.y - 180, home_position.y + 180)
		# Ya está en home, oscila para siempre (sin volver a chequear distancia)
		if is_shooting:
			shoot_pause -= delta
			velocity.y = 0
			velocity.x = SPEED
			if shoot_pause <= 0:
				is_shooting = false
				move_direction *= -1
				movement_cooldown = 1.7
		else:
			movement_cooldown -= delta
			velocity.y = SPEED_Y * move_direction
			if movement_cooldown <= 0:
				is_shooting = true
				shoot_pause = 1
				shoot_pattern()
				#Qué opinas de aquí? Que dispare a partir de aquí? 	
			
				
	move_and_slide()
	#-- EFECTOS VISUALES --
	update_damage_blink(delta)

func _ready():
	super()
	health = 7
	xp_value = 55
	home_position = Vector2(position.x, 324)

func on_death():
	var count = 12
	for i in count:
		var xp_orb = XP_ORB.instantiate()
		xp_orb.position = position
		get_parent().call_deferred("add_child", xp_orb)
		#Se suma 175 al puntaje
	GameData.score += 225.0
