extends Node2D

@onready var button = $Button  # Reference to the Button in the scene
@onready var other_scene = preload("res://OtherScene.tscn")  # Preload the other scene

func _ready():
	# Connect button press signal to a function
	button.connect("pressed", self, "_on_button_pressed")

# This function is called when the button is clicked
func _on_button_pressed():
	print("Button clicked!")
	show_other_scene()

# This function will load and display the other scene
func show_other_scene():
	var scene_instance = other_scene.instance()  # Create an instance of the other scene
	get_tree().root.add_child(scene_instance)  # Add the other scene to the root (this shows it)
	scene_instance.rect_position = Vector2.ZERO  # Position it at the top left of the screen if needed
