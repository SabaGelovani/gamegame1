extends Node2D

var speed = 10 
var moving = false  
var target_position = Vector2.ZERO  
var distance_threshold = 5.0  
var fuel_loss_rate = 200.0  
var distance_traveled = 0.0  

# References
@onready var moving_sprite = $Character  
@onready var target_sprites = [$PointA, $PointB, $PointC, $PointD, $PointE, $PointF]  
@onready var coin_manager = CoinManager  
@onready var money_popup = $MoneyPopup  
@onready var popup_label = $MoneyPopup/PopupLabel  
@onready var return_button = $ReturnButton

func _ready():
	load_game_data()
	
	if return_button:
		print("ReturnButton found!")
		return_button.pressed.connect(_on_return_button_pressed)
	else:
		print("ReturnButton not found!")

func _process(delta):
	if moving:
		var direction = (target_position - moving_sprite.position).normalized()
		var movement = direction * speed * delta

		moving_sprite.position += movement
		distance_traveled += movement.length()  

		if moving_sprite.position.distance_to(target_position) < distance_threshold:
			moving_sprite.position = target_position
			moving = false

			var fuel_lost_traveling = int(distance_traveled / fuel_loss_rate)
			if fuel_lost_traveling > 0:
				coin_manager.update_fuel(-fuel_lost_traveling)  
				distance_traveled = 0.0  

			process_coin_change(fuel_lost_traveling)  
			update_target_position()  
			save_game_data()  # Save progress

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		for sprite in target_sprites:
			if is_click_on_sprite(event.position, sprite):
				target_position = sprite.position
				moving = true  
				distance_traveled = 0.0  
				break  

func is_click_on_sprite(mouse_position, sprite):
	if not sprite or not sprite.texture:
		return false

	var sprite_rect = Rect2(
		sprite.global_position - (sprite.texture.get_size() * sprite.scale) / 2,
		sprite.texture.get_size() * sprite.scale
	)

	return sprite_rect.has_point(mouse_position)

func process_coin_change(fuel_lost_traveling):
	var coin_change_amount = randi() % 10 + 1  
	var fuel_change_amount = randi() % 2 + 1  

	var coin_gained = 0
	var coin_lost = 0

	if randi() % 2 == 0:
		coin_gained = coin_change_amount  
		coin_manager.update_money(coin_gained)
	else:
		coin_lost = coin_change_amount  
		coin_manager.update_money(-coin_lost)

	var fuel_gained = fuel_change_amount  
	coin_manager.update_fuel(fuel_gained)

	show_popup(coin_gained, coin_lost, fuel_gained, fuel_lost_traveling)
	save_game_data()  # Save progress

func show_popup(coin_amount, coin_loss, fuel_amount, fuel_lost_traveling):
	var coin_text = ""
	if coin_amount > 0:
		coin_text = "Gained " + str(coin_amount) + " coins!"
	elif coin_loss > 0:
		coin_text = "Lost " + str(coin_loss) + " coins!"

	var fuel_text = "Gained " + str(fuel_amount) + " fuel!"
	if fuel_amount > 0:
		fuel_text = "Gained " + str(fuel_amount) + " fuel!"

	var travel_fuel_text = "Burned " + str(fuel_lost_traveling) + " fuel traveling."

	var full_message = "\n".join([coin_text, fuel_text, travel_fuel_text]).strip_edges()

	popup_label.text = full_message  

	center_popup()
	money_popup.show()

	await get_tree().create_timer(2).timeout
	money_popup.hide()

func update_target_position():
	var current_index = target_sprites.find(target_position)
	if current_index != -1 and current_index < target_sprites.size() - 1:
		target_position = target_sprites[current_index + 1].position
	else:
		target_position = target_sprites[0].position  

func center_popup():
	var screen_size = get_viewport_rect().size
	money_popup.position = (screen_size - Vector2(money_popup.size.x, money_popup.size.y)) / 2

func _on_return_button_pressed():
	print("Return button clicked! Going back to Main Menu...")

	# Save progress before exiting
	save_game_data()

	# Load the main menu scene
	var main_menu_scene = load("res://MainMenu.tscn")  
	if main_menu_scene:
		var main_menu_instance = main_menu_scene.instantiate()
		get_tree().root.add_child(main_menu_instance)
		get_tree().current_scene = main_menu_instance  
	else:
		print("Failed to load Main Menu scene.")

# ---- SAVE & LOAD SYSTEM ---- #

func save_game_data():
	var save_data = {
		"position": {"x": moving_sprite.position.x, "y": moving_sprite.position.y},
		"coins": coin_manager.get_money(),  
		"fuel": coin_manager.get_fuel(),  
		"target": target_sprites.find(target_position)
	}
	
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game progress saved!")

func load_game_data():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var save_data = JSON.parse_string(file.get_as_text())
		file.close()

		if save_data:
			# Load position
			if "position" in save_data:
				moving_sprite.position = Vector2(save_data["position"]["x"], save_data["position"]["y"])

			# Load coins and fuel
			if "coins" in save_data:
				coin_manager.set_money(save_data["coins"])
			if "fuel" in save_data:
				coin_manager.set_fuel(save_data["fuel"])

			# Load target position
			if "target" in save_data and save_data["target"] < target_sprites.size():
				target_position = target_sprites[save_data["target"]].position

			print("Game progress loaded successfully!")
