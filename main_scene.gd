extends Node2D

@onready var popup_scene = preload("res://PopupScene.tscn")
@onready var popup_instance = null
@onready var open_popup_button = $OpenPopupButton

func _ready():
	open_popup_button.pressed.connect(_on_open_popup_pressed)

func _on_open_popup_pressed():
	if popup_instance == null:
		popup_instance = popup_scene.instantiate()
		add_child(popup_instance)
		popup_instance.show()
	else:
		popup_instance.show()
