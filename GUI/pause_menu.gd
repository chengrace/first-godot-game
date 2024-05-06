## pause_menu.gd

extends CanvasLayer

@onready var button_sound = $ButtonSound

signal resumed

var skip_first_button_sound = false #true when completed

func on_open():
	skip_first_button_sound = false
	$Resume.grab_focus()

func _on_main_menu_pressed():
	SceneManager.change_scene_with_transition("res://Scenes/main.tscn")

func _on_resume_pressed():
	SceneManager.is_paused = false
	resumed.emit()
	
func _on_quit_pressed():
	get_tree().quit()

func _on_resume_focus_entered():
	if skip_first_button_sound:
		button_sound.play()
	else:
		skip_first_button_sound = true

func _on_main_menu_focus_entered():
	button_sound.play()

func _on_quit_focus_entered():
	button_sound.play()
