##house_area.gd

extends Node2D

@onready var animation_player = $Transition

#only after scene has been changed, do we free our resource     
func _on_scene_changed():
	queue_free()

# Exit to new area
func _on_exit_area_body_entered(body):
	if body.is_in_group("player"):
		Global.change_scene_with_transition("res://Scenes/forest_area.tscn")
		Global.scene_changed.connect(_on_scene_changed)

func _on_enter_house_body_entered(body):
	if body.is_in_group("player"):
		Global.change_scene_with_transition("res://Scenes/apartment_area.tscn")
		Global.scene_changed.connect(_on_scene_changed)
