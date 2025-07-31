extends Node2D

@onready var popup = $Popup
@onready var button = $OpenPopupButton

func _ready():
	button.pressed.connect(open_popup)
	popup.hide()  # Start hidden

func open_popup():
	popup.show()

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		if popup.visible:
			popup.hide()
