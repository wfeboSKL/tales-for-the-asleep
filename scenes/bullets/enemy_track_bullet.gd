extends Area2D

const SPEED = 450
var is_homing = true
var homing_duration = 1.0
var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _process(delta: float) -> void:
	position += Vector2.LEFT.rotated(rotation) * SPEED * delta
	if is_homing:
		var angle_to_player = global_position.angle_to_point(player.global_position)
		rotation = lerp_angle(rotation, angle_to_player + PI, 5.0 * delta)
		homing_duration -= delta
		if homing_duration <= 0:
			is_homing = false
	if position.x < 0:
		queue_free()
func _on_body_entered(body):
	#Si el cuerpo que toca está en el grupo "Player" tomará 1 de daño y se eliminará
	if body.is_in_group("Player"):
		body.take_damage(1)
		queue_free()
