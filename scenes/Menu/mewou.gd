extends Control

const CHAPTER_1 = "res://scenes/demolevel/level.tscn"
const CHAPTER_2 = "res://scenes/chapter_2.tscn"
const CHAPTER_3 = "res://scenes/chapter_3.tscn"

func _ready():
	# Conectar botones
	$BookshelfPanel/VBoxContainer/Chapter1Button.pressed.connect(_on_chapter1_pressed)
	$BookshelfPanel/VBoxContainer/Chapter2Button.pressed.connect(_on_chapter2_pressed)
	$BookshelfPanel/VBoxContainer/Chapter3Button.pressed.connect(_on_chapter3_pressed)
	$BookshelfPanel/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

	# Fondo oscuro
	$Background.color = Color("#1a0e05")

	# Panel central
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color("#2a1505")
	panel_style.border_color = Color("#5a3010")
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(6)
	$BookshelfPanel.add_theme_stylebox_override("panel", panel_style)

	# Tamaño y posición del panel
	$BookshelfPanel.custom_minimum_size = Vector2(400, 420)
	$BookshelfPanel.set_anchors_preset(Control.PRESET_CENTER)

	# Separación entre botones
	$BookshelfPanel/VBoxContainer.add_theme_constant_override("separation", 10)

	# Título
	var title = $BookshelfPanel/VBoxContainer/TitleLabel
	title.text = "📚 La Gran Biblioteca"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color("#f5d78a"))
	title.add_theme_font_size_override("font_size", 26)

	# Textos de los botones
	$BookshelfPanel/VBoxContainer/Chapter1Button.text = "Capítulo I"
	$BookshelfPanel/VBoxContainer/Chapter2Button.text = "Capítulo II"
	$BookshelfPanel/VBoxContainer/Chapter3Button.text = "Capítulo III"
	$BookshelfPanel/VBoxContainer/QuitButton.text = "🚪  Cerrar el libro"

	# Estilo a cada botón
	_apply_book_style($BookshelfPanel/VBoxContainer/Chapter1Button)
	_apply_book_style($BookshelfPanel/VBoxContainer/Chapter2Button)
	_apply_book_style($BookshelfPanel/VBoxContainer/Chapter3Button)
	_apply_quit_style($BookshelfPanel/VBoxContainer/QuitButton)

# Estilo madera dorada
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

	var pressed = StyleBoxFlat.new()
	pressed.bg_color = Color("#7A4015")
	pressed.border_color = Color("#FFD700")
	pressed.set_border_width_all(2)
	pressed.set_corner_radius_all(4)
	button.add_theme_stylebox_override("pressed", pressed)

	button.add_theme_color_override("font_color", Color("#E8C87A"))
	button.add_theme_color_override("font_hover_color", Color("#FFD98A"))

# Estilo oscuro para Salir
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

# --- Funciones de botones ---
func _on_chapter1_pressed():
	get_tree().change_scene_to_file(CHAPTER_1)

func _on_chapter2_pressed():
	get_tree().change_scene_to_file(CHAPTER_2)

func _on_chapter3_pressed():
	get_tree().change_scene_to_file(CHAPTER_3)

func _on_quit_pressed():
	get_tree().quit()
