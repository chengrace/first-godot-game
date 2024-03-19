## main.gd

extends Node2D

@onready var animation_player = $AnimationPlayer

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/house_area.tscn")
	animation_player.play("fade_out")

func _on_load_game_pressed():
	pass # Replace with function body.

func _on_quit_game_pressed():
	get_tree().quit()
