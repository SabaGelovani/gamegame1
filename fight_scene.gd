extends Node2D

@export var enemy_scene: PackedScene
@export var drone_scene: PackedScene
@export var spawn_interval: float = 3.0
@export var drone_interval: float = 1.5
@export var spawn_radius: float = 400.0

@onready var player = $PlayerShip
@onready var enemy_container = $EnemyContainer
@onready var drone_container = $DroneContainer
@onready var button = $Button

func _ready():
	spawn_enemy()
	spawn_drone()
	spawn_enemy_timer()
	spawn_drone_timer()

func spawn_enemy_timer():
	await get_tree().create_timer(spawn_interval).timeout
	spawn_enemy()
	spawn_enemy_timer()

func spawn_drone_timer():
	while true:
		await get_tree().create_timer(drone_interval).timeout

		# Check if any enemy is close enough before spawning drone
		var enemy_close = false
		for enemy in enemy_container.get_children():
			if enemy.global_position.distance_to(player.global_position) <= 500:
				enemy_close = true
				break

		if enemy_close:
			spawn_drone()


func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	# Distance from player to spawn enemies
	var radius = 300  
	
	# Random angle
	var angle = randf() * TAU  
	
	# Get offset from player position
	var offset = Vector2(cos(angle), sin(angle)) * radius
	
	# Set position around the player
	enemy.global_position = player.global_position + offset

	enemy_container.add_child(enemy)
	print("Enemy spawned at:", enemy.global_position)

func spawn_drone():
	if not drone_scene or not player:
		return
	var drone = drone_scene.instantiate()
	drone.global_position = player.global_position
	drone_container.add_child(drone)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
