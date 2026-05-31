extends Node2D

func _process(delta: float) -> void:
	$ParallaxBackground.scroll_offset.x -= 90 * delta
