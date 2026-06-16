extends Control

# Rutas de las escenas de cada capítulo
# ¡Cambia estas rutas por las de tu proyecto!
const CHAPTER_1 = "res://scenes/chapter_1.tscn"
const CHAPTER_2 = "res://scenes/chapter_2.tscn"
const CHAPTER_3 = "res://scenes/chapter_3.tscn"

func _ready():
	# Conectar señales de cada botón a sus funciones
	$BookshelfPanel/VBoxContainer/Chapter1Button.pressed.connect(_on_chapter1_pressed)
	$BookshelfPanel/VBoxContainer/Chapter2Button.pressed.connect(_on_chapter2_pressed)
	$BookshelfPanel/VBoxContainer/Chapter3Button.pressed.connect(_on_chapter3_pressed)
	$BookshelfPanel/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

# --- Funciones de cada botón ---

func _on_chapter1_pressed():
	get_tree().change_scene_to_file(CHAPTER_1)

func _on_chapter2_pressed():
	get_tree().change_scene_to_file(CHAPTER_2)

func _on_chapter3_pressed():
	get_tree().change_scene_to_file(CHAPTER_3)

func _on_quit_pressed():
	get_tree().quit()extends Control

# Rutas de las escenas de cada capítulo
# ¡Cambia estas rutas por las de tu proyecto!
const CHAPTER_1 = "res://scenes/chapter_1.tscn"
const CHAPTER_2 = "res://scenes/chapter_2.tscn"
const CHAPTER_3 = "res://scenes/chapter_3.tscn"

func _ready():
	# Conectar señales de cada botón a sus funciones
	$BookshelfPanel/VBoxContainer/Chapter1Button.pressed.connect(_on_chapter1_pressed)
	$BookshelfPanel/VBoxContainer/Chapter2Button.pressed.connect(_on_chapter2_pressed)
	$BookshelfPanel/VBoxContainer/Chapter3Button.pressed.connect(_on_chapter3_pressed)
	$BookshelfPanel/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

# --- Funciones de cada botón ---

func _on_chapter1_pressed():
	get_tree().change_scene_to_file(CHAPTER_1)

func _on_chapter2_pressed():
	get_tree().change_scene_to_file(CHAPTER_2)

func _on_chapter3_pressed():
	get_tree().change_scene_to_file(CHAPTER_3)

func _on_quit_pressed():
	get_tree().quit()
