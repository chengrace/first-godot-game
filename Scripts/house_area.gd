##house_area.gd

extends Node2D

@onready var animation_player = $Transition

func _ready():
	animation_player.play("fade_in")

func _on_exit_area_body_entered(body):
	print("entered")
	print(body.name)
	if body.is_in_group("player"):
		print("player entered")
		Global.change_scene("res://Scenes/new_area.tscn")
		Global.scene_changed.connect(_on_scene_changed)

#only after scene has been changed, do we free our resource     
func _on_scene_changed():
	queue_free()
