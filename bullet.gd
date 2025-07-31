extends Area2D

@export var speed: float = 600.0
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * delta

	if not get_viewport_rect().has_point(global_position):
		queue_free()
