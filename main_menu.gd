extends Control

@onready var play_button = $PlayButton
@onready var skilltree_button = $SkillTreeButton
@onready var fight_button = $FightButton

func _ready():
	play_button.pressed.connect(_on_play_button_pressed)
	skilltree_button.pressed.connect(_on_skilltree_button_pressed)
	fight_button.pressed.connect(_on_fight_button_pressed)
	
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Node2D.tscn")

func _on_skilltree_button_pressed():
	get_tree().change_scene_to_file("res://SkillTree.tscn")

func _on_fight_button_pressed():
	get_tree().change_scene_to_file("res://fight_scene.tscn")
