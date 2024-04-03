## main.gd

extends Node2D

@onready var new_game_button = %NewGame
@onready var button_sound = $ButtonSound

var skip_first_button_sound = false #true when completed
var stop_input = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	skip_first_button_sound = false
	new_game_button.grab_focus()

func _on_new_game_pressed():
	Global.change_scene_with_transition("res://Scenes/house_area.tscn", "dissolve")

func _on_load_game_pressed():
	Global.is_saving = false
	Global.change_scene_with_transition("res://Scenes/load_game.tscn")

func _on_quit_game_pressed():
	get_tree().quit()
	
func _on_new_game_focus_entered():
	if skip_first_button_sound:
		button_sound.play()
	else:
		skip_first_button_sound = true

func _on_load_game_focus_entered():
	button_sound.play()

func _on_quit_game_focus_entered():
	button_sound.play()
