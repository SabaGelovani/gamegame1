extends TextureButton
class_name SkillNode

signal skill_toggled(active: bool)

@onready var label: Label = $Label

var active := false  # ჩართვა/გამორთვა
var level := 0  # დონე

func _ready() -> void:
	update_ui()
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	level += 1  # ყოველ დაჭერაზე დონე ერთი გაიზრდება
	update_ui()
	emit_signal("skill_toggled", active)

func update_ui() -> void:
	if label:
		label.text = "Level: %d" % level
