extends Area2D
const SPEED = 1050.0
func _process(delta: float) -> void:
	position.x += SPEED*delta
