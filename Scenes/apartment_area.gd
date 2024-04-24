extends Node2D

@onready var bgm = $BGM

func _ready():
	bgm.play()
	#Global.scene_changed.connect(_on_scene_changed)
#
func _on_exit_house_body_entered(body):
	if body.is_in_group("player"):
		Global.change_scene_with_transition("res://Scenes/house_area.tscn")
		
#func _on_go_upstairs_body_entered(body):
	#if body.is_in_group("player"):
		#Global.change_scene_with_transition("res://Scenes/new_area.tscn")
#
##only after scene has been changed, do we free our resource     
func _on_scene_changed():
	queue_free()
