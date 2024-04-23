## main.gd

extends Node2D

@onready var new_game_button = %NewGame
@onready var button_sound = $ButtonSound

var skip_first_button_sound = false #true when completed

func _ready():
	$AnimationPlayer.play("slide_in")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	skip_first_button_sound = false
	new_game_button.grab_focus()

func process():
	# While animation is playing, don't accept any button input
	if !$Timer.is_stopped():
		set_process_input(false)
		set_process_unhandled_input(false)
	else:
		set_process_input(true)

func _input(event):
	if !$Timer.is_stopped():
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_focus_next") or event.is_action_pressed("ui_focus_prev"):
			$AnimationPlayer.set_speed_scale(7)
			button_sound.play()

func _on_new_game_pressed():
	Global.change_scene_with_transition("res://Scenes/apartment_area.tscn", "dissolve", Color.BLACK)

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
