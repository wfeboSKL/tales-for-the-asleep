extends CharacterBody2D
const BULLET = preload("res://scenes/bullet.tscn")
const SPEED = 300.0
const SPEED_FOCUSED = 150.0
var is_focused = false
func _physics_process(delta: float) -> void:
	is_focused = Input.is_action_pressed("ui_select")
	var speed = SPEED_FOCUSED if is_focused else SPEED
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction*speed
	move_and_slide()
	var screen = get_viewport_rect().size
	position.x = clamp(position.x,16,screen.x-16)
	position.y = clamp(position.y,16,screen.y-16)
	if Input.is_action_just_pressed("ui_accept"):
		var bullet = BULLET.instantiate()
		bullet.position = position
		get_parent().add_child(bullet)
