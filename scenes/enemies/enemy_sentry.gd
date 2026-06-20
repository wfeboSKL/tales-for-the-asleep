extends "res://scripts/enemies/enemy_base.gd"

var in_home = false
var is_shooting = false
var home_position = Vector2.ZERO

var movement_cooldown = 0.0
var shoot_pause = 0.0
const SPEED = 140.0
const SPEED_Y = 270.0
var move_direction = -1

func _physics_process(delta: float) -> void:
	if not in_home:
		# Todavía no llegó, sigue cayendo
		velocity.y = move_toward(velocity.y, home_position.y, SPEED_Y)
		if position.distance_to(home_position) < 5:
			in_home = true
	else:
		# Ya está en home, oscila para siempre (sin volver a chequear distancia)
		if is_shooting:
			shoot_pause -= delta
			velocity.y = 0
			if shoot_pause <= 0:
				is_shooting = false
				move_direction *= -1
				movement_cooldown = 1.7
				
				print("ACABÓ SHOOT_PAUSE")
		else:
			movement_cooldown -= delta
			velocity.y = SPEED_Y * move_direction
			if movement_cooldown <= 0:
				is_shooting = true
				shoot_pause = 1
				print("ACABÓ MOVEMENT_COOLDOWN")
	move_and_slide()
	position.y = clamp(position.y, home_position.y - 180, home_position.y + 180)

func _ready():
	super()
	health = 7
	xp_value = 55
	# Guardamos la posición X actual, pero con una Y específica como destino "home"
	home_position = Vector2(position.x, 324)
