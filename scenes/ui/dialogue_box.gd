extends CanvasLayer
var current_text = ""
var current_line = 0
var letter_timer = 0.0
var dialogue_lines = []
var current_displayed_text = ""
var current_character_speaking = ""
var letter_speed = 0.05
var is_dialogue_active = false

# -- DICCIONARIO DE SPRITES POR PERSONAJE --
var character_sprites = {
	"Desivinte:": preload("res://Sprites/Dialogue/DesivinteDialogue.png"),
	"Morthalias:": preload("res://Sprites/Dialogue/MorthaliasDialogue.png")
}

func update_character_sprites():
	if current_character_speaking == "Desivinte:":
		# Desivinte habla: él se ilumina, el otro se oscurece
		$LeftCharacter.modulate = Color.WHITE
		$RightCharacter.modulate = Color(0.4, 0.4, 0.4)
	else:
		# Otro personaje habla: él se ilumina, Desivinte se oscurece
		$RightCharacter.texture = character_sprites[current_character_speaking]
		$RightCharacter.modulate = Color.WHITE
		$LeftCharacter.modulate = Color(0.4, 0.4, 0.4)

func _process(delta: float) -> void:
	if not is_dialogue_active:
		return
	if current_displayed_text.length() < current_text.length():
		letter_timer += delta
		if letter_timer >= letter_speed:
			letter_timer = 0.0
			current_displayed_text += current_text[current_displayed_text.length()]
			$DialoguePanel/DialogueText.text = current_displayed_text

func show_current_line():
	current_text = dialogue_lines[current_line][1]
	current_character_speaking = dialogue_lines[current_line][0]
	current_displayed_text = ""
	letter_timer = 0.0
	$DialoguePanel/DialogueText.text = ""
	$DialoguePanel/CharacterName.text = current_character_speaking
	update_character_sprites()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	$LeftCharacter.texture = character_sprites["Desivinte:"]
	

func start_dialogue(lines: Array):
	dialogue_lines = lines
	current_line = 0
	is_dialogue_active = true
	visible = true 
	get_tree().paused = true
	show_current_line()

func next_line():
	current_line += 1
	if current_line < dialogue_lines.size():
		show_current_line()
	else:
		end_dialogue()

func _input(event: InputEvent) -> void:
	if not is_dialogue_active:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		if current_displayed_text.length() < current_text.length():
			current_displayed_text = current_text
			$DialoguePanel/DialogueText.text = current_text
		else:
			next_line()

func end_dialogue():
	is_dialogue_active = false
	visible = false
	get_tree().paused = false
