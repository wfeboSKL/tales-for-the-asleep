#-- VARIABLES INICIALES DEL PLAYER --
#Conectar Script con CharacterBody2D
extends CharacterBody2D
#Pre-cargar la bala para evitar que el juego baje en funcionamiento
const BULLET = preload("res://scenes/bullets/bullet.tscn")
#Pre-cargar la escena de Game Over
const GAME_OVER = preload("res://scenes/ui/game_over.tscn")
#Pre-cargar el ataque melee
const MELEE = preload("res://scenes/player/melee_attack.tscn")
#Definir la velocidad del jugador
const SPEED = 300.0
#Definir la velocidad del jugador en estado "focus" (estado de movimiento lento)
const SPEED_FOCUSED = 150.0
#Está focused? No, hasta que se dicte lo contrario
var is_focused = false
#Cooldown entre balas para que tengan un espacio entre ellas
var shoot_cooldown = 0.0
#Cooldown entre daño tomado para tener invencibilidad
var invincibility_timer = 0.0
#Establecer la vida del jugador
var health = 5
#Cooldown de melee 
var melee_cooldown = 0.0

#Cuando el jugador esté en la escena, crear health_bar
@onready var health_bar = get_parent().get_node("HUD/ProgressBar")
@onready var score_label = get_parent().get_node("HUD/ScoreLabel")
#-- MOVIMIENTO DEL JUGADOR --
#Función que procesa las físicas ocurriendo cada frame (delta)
func _physics_process(delta: float) -> void:
	#is_focused cambiará de false a true dependiendo si el jugador está presionando "focus"
	#"focus" está asignado a shift
	is_focused = Input.is_action_pressed("focus")
	#La velocidad será siempre SPEED_FOCUSED (150.0) si if_focused es true, sino será SPEED (300.0)
	var speed = SPEED_FOCUSED if is_focused else SPEED
	#La dirección del jugador se define en get_vector (todos los ejes): Izq, der, arr, abj
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	#Velocity define la dirección y rapidez del jugador
	#Por ej. derecha sería (1,0), arriba sería (0,-1) [-1 porque arriba es -y]
	velocity = direction*speed
	#Se realiza el cálculo final de las físicas con esta línea de código
	move_and_slide()
	
	#-- LIMITES DE LA PANTALLA --
	var screen = get_viewport_rect().size
	position.x = clamp(position.x,16,screen.x-16)
	position.y = clamp(position.y,16,screen.y-16)
	# -- CONFIGURACIONES DE BALAS
	#Debido a que está dentro de la función (la cual revisa cada frame que pasa)
	#shoot_cooldown se le restará delta cada frame que pase (1/60 o 1/24 dependiendo del framerate)
	shoot_cooldown -= delta
	#invincibility_timer se le restará delta cada frame que pase
	invincibility_timer -= delta
	#fmod oscila entre 0 y 0.2, crea un interruptor para que este parpadee cada 0.1 segundos
	#Si el timer es mayor a 0, este hará que el sprite parpadee
	if invincibility_timer > 0:
		$Sprite2D.visible = fmod(invincibility_timer, 0.2) > 0.1
	#De lo contrario, este será visible siempre
	else:
		$Sprite2D.visible = true
	#Si "shoot" [k] es presionado y el cooldown está en 0 [o menos]:
	if Input.is_action_pressed("shoot") and shoot_cooldown <= 0:
		#La variable bala crea (o instancia) la escena BULLET
		var bullet = BULLET.instantiate()
		#La posición inicial de la bala será la misma que la del jugador
		bullet.position = position
		#Esto añade la bala como un nodo hijo al Player
		get_parent().add_child(bullet)
		#Se reinicia el cooldown de la bala para que en los siguientes frames se resta por delta
		shoot_cooldown = 0.1
	melee_cooldown -= delta
	if Input.is_action_just_pressed("melee") and melee_cooldown <= 0:
		var melee = MELEE.instantiate()
		melee.position = position
		get_parent().add_child(melee)
		melee_cooldown = 7.5
	score_label.text = "Puntaje: " + str(GameData.score)
#--TOMAR DAÑO--
#Función que registra el daño tomado de un enemigo, amount es un valor específicado en enemy
func take_damage(amount):
	if invincibility_timer <= 0:
		#Cada vez que se activa esta función, se le restará "amount" al jugador (su variable health)
		health -= amount
		#El texto que demuestra la vida del jugador mostrará ahora la vida actual (hay que cambiar esto)
		health_bar.value = health
		#Si la vida es menor o igual a 0, eliminar al jugador e instanciar escena de Game Over
		if health <= 0:
			GameData.score = 0.0
			var game_over = GAME_OVER.instantiate()
			get_parent().add_child(game_over)
			queue_free()
		#Reiniciar temporizador de invencibilidad
		invincibility_timer = 1.5
