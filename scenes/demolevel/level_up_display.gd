extends CanvasLayer

func _ready():
	# Al iniciar, conectar la señal level_up_occurred de GameData a esta función
	GameData.level_up_occurred.connect(_on_level_up_occurred)

func _on_level_up_occurred(player_level):
	$LevelUpLabel.text = "Nivel: " + str(player_level)
	# Se crea una animación (Tween) para el efecto de aparición/desaparición
	var tween = create_tween()
	# Fade in: de invisible a totalmente visible en 0.3 segundos
	tween.tween_property($LevelUpLabel, "modulate:a", 1.0, 0.3)
	# Espera 1.5 segundos visible antes de desaparecer
	tween.tween_interval(1.5)
	# Fade out: de visible a invisible en 0.3 segundos
	tween.tween_property($LevelUpLabel, "modulate:a", 0.0, 0.3)
