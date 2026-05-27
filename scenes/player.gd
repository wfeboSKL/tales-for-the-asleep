#-- VARIABLES INICIALES DEL PLAYER --
#Conectar Script con CharacterBody2D
extends CharacterBody2D
#Pre-cargar la bala para evitar que el juego baje en funcionamiento
const BULLET = preload("res://scenes/bullet.tscn")
#Definir la velocidad del jugador
const SPEED = 300.0
#Definir la velocidad del jugador en estado "focus" (estado de movimiento lento)
const SPEED_FOCUSED = 150.0
#Está focused? No, hasta que se dicte lo contrario
var is_focused = false
#Cooldown entre balas para que tengan un espacio entre ellas
var shoot_cooldown = 0.0
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
