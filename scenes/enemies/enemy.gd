extends CharacterBody2D
const SPEED = 150.0
var health = 3
var shoot_cooldown = 0.0
func _physics_process(delta: float) -> void:
	velocity.x = -SPEED
	move_and_slide()
	if position.x< -50:
		queue_free()
func take_damage(amount):
	print("Daño recibido: ", amount, " Vida actual: ", health)
	health -= amount
	if health <= 0:
		queue_free()
	
