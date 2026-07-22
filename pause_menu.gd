extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Pausamos el juego inmediatamente al crearse este menú
	get_tree().paused = true

	# Overlay oscuro
	$Control/Overlay.color = Color(0, 0, 0, 0.7)
	$Control/Overlay.set_anchors_preset(Control.PRESET_FULL_RECT)

	# Panel central
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color("#2a1505")
	panel_style.border_color = Color("#5a3010")
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(6)
	$Control/PanelContainer.add_theme_stylebox_override("panel", panel_style)
	$Control/PanelContainer.custom_minimum_size = Vector2(420, 0)
	$Control/PanelContainer.set_anchors_preset(Control.PRESET_CENTER)

	# Separación
	$Control/PanelContainer/VBoxContainer.add_theme_constant_override("separation", 12)

	# Título
	var title = $Control/PanelContainer/VBoxContainer/TitleLabel
	title.text = "⏸  Juego en Pausa"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color("#f5d78a"))
	title.add_theme_font_size_override("font_size", 22)

	# Controles
	var controls = $Control/PanelContainer/VBoxContainer/ControlsLabel
	controls.text = """🎮 Controles:
	
	WASD / Flechas  →  Moverse
	Espacio         →  Saltar
	Shift           →  Correr
	ESC             →  Pausar / Reanudar
	
	💡 Tu progreso se guarda automáticamente
	al completar cada capítulo."""
	controls.add_theme_color_override("font_color", Color("#a07840"))
	controls.add_theme_font_size_override("font_size", 13)

	# Botones
	$Control/PanelContainer/VBoxContainer/ResumeButton.text = "▶  Reanudar"
	$Control/PanelContainer/VBoxContainer/QuitButton.text = "🚪  Salir al menú principal"

	_apply_book_style($Control/PanelContainer/VBoxContainer/ResumeButton)
	_apply_quit_style($Control/PanelContainer/VBoxContainer/QuitButton)

	# Conectar botones
	$Control/PanelContainer/VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$Control/PanelContainer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _input(event: InputEvent) -> void:
	# ESC pausa/reanuda sin importar si hay diálogo activo
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()  # evita que el ESC lo atrape otro nodo
		_resume()

func _resume() -> void:
	get_tree().paused = false
	queue_free()

func _on_resume_pressed() -> void:
	_resume()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menu/Mewou.tscn")

func _apply_book_style(button: Button):
	button.custom_minimum_size = Vector2(0, 50)
	button.add_theme_font_size_override("font_size", 15)

	var normal = StyleBoxFlat.new()
	normal.bg_color = Color("#3D1F0A")
	normal.border_color = Color("#C8922A")
	normal.set_border_width_all(2)
	normal.set_corner_radius_all(4)
	button.add_theme_stylebox_override("normal", normal)

	var hover = StyleBoxFlat.new()
	hover.bg_color = Color("#5C3010")
	hover.border_color = Color("#FFD700")
	hover.set_border_width_all(2)
	hover.set_corner_radius_all(4)
	button.add_theme_stylebox_override("hover", hover)

	button.add_theme_color_override("font_color", Color("#E8C87A"))
	button.add_theme_color_override("font_hover_color", Color("#FFD98A"))

func _apply_quit_style(button: Button):
	button.custom_minimum_size = Vector2(0, 50)
	button.add_theme_font_size_override("font_size", 15)

	var normal = StyleBoxFlat.new()
	normal.bg_color = Color("#280A05")
	normal.border_color = Color("#5a3010")
	normal.set_border_width_all(2)
	normal.set_corner_radius_all(4)
	button.add_theme_stylebox_override("normal", normal)

	var hover = StyleBoxFlat.new()
	hover.bg_color = Color("#4A1008")
	hover.border_color = Color("#C86040")
	hover.set_border_width_all(2)
	hover.set_corner_radius_all(4)
	button.add_theme_stylebox_override("hover", hover)

	button.add_theme_color_override("font_color", Color("#8A5030"))
	button.add_theme_color_override("font_hover_color", Color("#C86040"))
