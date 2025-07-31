extends Node2D()

# Declare variables inside the class body
onready var sprite1 = $Sprite2D  # Reference to the first sprite
onready var sprite2 = $Sprite2D2  # Reference to the second sprite (target)

var speed = 300  # Speed at which sprite1 moves
var target_position = Vector2.ZERO  # Target position for sprite1
var is_moving = false  # Flag to track whether sprite1 is moving

# _process function runs every frame
func _process(delta):
	if is_moving:
		# Calculate the direction from sprite1 to sprite2
		var direction = target_position - sprite1.position
		if direction.length() > 1:  # Only move if sprite1 is not at the target
			sprite1.position += direction.normalized() * speed * delta
		else:
			sprite1.position = target_position  # Snap to the target if it's very close
			is_moving = false  # Stop the movement once we reach the target

# _input function handles input events (like key presses)
func _input(event):
	if event is InputEventAction and event.pressed and event.action == "My_action":
		# Set the target position to sprite2's position when My_action is triggered
		target_position = sprite2.position
		is_moving = true  # Start the movement
