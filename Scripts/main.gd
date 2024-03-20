## main.gd

extends Node2D

@onready var animation_player = $Transition

func _on_new_game_pressed():
	animation_player.play("fade_out")

func _on_load_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/house_area.tscn")

func _on_quit_game_pressed():
	get_tree().quit()

func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/house_area.tscn")
