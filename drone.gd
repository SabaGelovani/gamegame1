extends Area2D

@export var speed: float = 100.0
var target: Node2D

func _ready():
	find_target()
	self.body_entered.connect(_on_body_entered)

func _process(delta):
	if target and is_instance_valid(target):
		var dir = (target.global_position - global_position).normalized()
		global_position += dir * speed * delta
	else:
		find_target()

func find_target():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0:
		target = enemies[0]

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()   # Destroy enemy
		queue_free()        # Destroy drone
