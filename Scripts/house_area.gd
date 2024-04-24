##house_area.gd

extends Node2D

@onready var animation_player = $Transition

var new_area_path = ""

func _ready():
	Global.scene_changed.connect(_on_scene_changed)	

func _input(event):
	if Input.is_action_pressed("ui_action"):
		if new_area_path != "":
			Global.change_scene_with_transition(new_area_path)

# Changes to different area, doesn't require player input
func _on_exit_area_body_entered(body):
	if body.is_in_group("player"):
		Global.change_scene_with_transition("res://Scenes/forest_area.tscn")

# Enters the house, requires player input at door
func _on_enter_house_body_entered(body):
	if body.is_in_group("player"):
		new_area_path = "res://Scenes/apartment_area.tscn"
	
#only after scene has been changed, do we free our resource     
func _on_scene_changed():
	queue_free()
