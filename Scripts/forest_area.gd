##forest_area.gd

extends Node2D

func _ready():
	$BGM.play()

#only after scene has been changed, do we free our resource     
func _on_scene_changed():
	queue_free()

func _on_house_area_enter_body_entered(body):
	if body.is_in_group("player"):
		Global.change_scene_with_transition("res://Scenes/house_area.tscn")
		Global.scene_changed.connect(_on_scene_changed)
