## main.gd

extends Node2D

@onready var animation_player = $Transition
@onready var new_game_button = $Background/NewGame
@onready var button_sound = $ButtonSound

var skip_first_button_sound = false #true when completed

func _ready():
	#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	skip_first_button_sound = false
	new_game_button.grab_focus()

func _on_new_game_pressed():
	animation_player.play("fade_out")

func _on_load_game_pressed():
	Global.is_saving = false
	get_tree().change_scene_to_file("res://Scenes/load_game.tscn")

func _on_quit_game_pressed():
	get_tree().quit()

func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/house_area.tscn")

func _on_new_game_focus_entered():
	if skip_first_button_sound:
		button_sound.play()
	else:
		skip_first_button_sound = true

func _on_load_game_focus_entered():
	button_sound.play()

func _on_quit_game_focus_entered():
	button_sound.play()
