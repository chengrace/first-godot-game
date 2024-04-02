##house_area.gd

extends Node2D

@onready var animation_player = $Transition

# Exit to new area
func _on_exit_area_body_entered(body):
	if body.is_in_group("player"):
		Global.change_scene_with_transition("res://Scenes/new_area.tscn", "wipe")
		Global.scene_changed.connect(_on_scene_changed)

#only after scene has been changed, do we free our resource     
func _on_scene_changed():
	queue_free()
