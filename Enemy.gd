extends CharacterBody2D

@export var speed: float = 50.0
var player: Node2D

func _ready():
	add_to_group("enemies")
	# Adjust the path below to your actual player path in FightScene
	player = get_tree().get_root().get_node("FightScene/PlayerShip") 

func _physics_process(delta):
	if player and is_instance_valid(player):
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func die():
	queue_free()

# This is called by the drone via collision (see next note)
func _on_hit_by_drone():
	die()
