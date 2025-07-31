extends Sprite2D

@export var detection_radius: float = 100.0
@export var bullet_scene: PackedScene = preload("res://Bullet.tscn")

@onready var shot_timer: Timer = $ShotTimer
@onready var bullet_pool: Node = get_parent().get_node("BulletPool")

func _physics_process(_delta: float) -> void:
	var target := _find_target()
	if target and shot_timer.is_stopped():
		_shoot_at(target.global_position)

func _find_target() -> Node2D:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.global_position.distance_to(global_position) <= detection_radius:
			return enemy
	return null

func _shoot_at(target_pos: Vector2) -> void:
	shot_timer.start()
	var bullet = bullet_scene.instantiate()

	# ✅ MAKE SURE it's placed exactly where the player is
	bullet.global_position = global_position

	# ✅ Aim at the enemy
	var dir = (target_pos - global_position).normalized()
	bullet.velocity = dir * bullet.speed

	bullet_pool.add_child(bullet)
