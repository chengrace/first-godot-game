extends Node2D

@onready var bgm = $BGM

var new_area_path = ""

func _ready():
	bgm.play()
	#Global.scene_changed.connect(_on_scene_changed)
	
func _input(event):
	if Input.is_action_pressed("ui_action"):
		if new_area_path != "":
			Global.change_scene_with_transition(new_area_path)
#
func _on_exit_house_body_entered(body):
	if body.is_in_group("player"):
		new_area_path = "res://Scenes/house_area.tscn"

func _on_exit_house_body_exited(body):
	if body.is_in_group("player"):
		new_area_path = ""
		
func _on_go_upstairs_body_entered(body):
	if body.is_in_group("player"):
		Global.change_scene_with_transition("res://Scenes/forest_area.tscn")
#
##only after scene has been changed, do we free our resource     
#func _on_scene_changed():
	#queue_free()



