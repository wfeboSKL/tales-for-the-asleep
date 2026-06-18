extends CanvasLayer
@onready var xp_label = $XPBar/XPLabel

func _ready():
	# Al iniciar, conectar la señal xp_changed de GameData a esta función
	GameData.xp_changed.connect(_on_xp_changed)
	# Establecer el máximo inicial de la barra de XP
	$XPBar.max_value = GameData.xp_to_next_level

# -- ACTUALIZAR BARRA DE XP --
# Esta función se ejecuta cada vez que GameData emite xp_changed
func _on_xp_changed(current_xp, max_xp):
	$XPBar.value = current_xp
	$XPBar.max_value = max_xp
	xp_label.text = "Nivel: " + str(GameData.player_level)
