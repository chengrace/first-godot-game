## scene_transition.gd

extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var color_transition = $DissolveRect

signal anim_in_finished

var in_transition_finished

func play_transition(anim_name, color):
	if anim_name == "none":
		anim_in_finished.emit()
	else:
		if anim_name == "dissolve" :
			color_transition.color = color
			animation_player.play(anim_name)
		elif anim_name == "wipe":
			color_transition.color = color
			animation_player.play("wipe_in")
		in_transition_finished = true

func _on_animation_player_animation_finished(anim_name):
	if in_transition_finished:
		#print("First half of transition is done")
		anim_in_finished.emit() 
		if anim_name == "dissolve":
			animation_player.play_backwards("dissolve")
		elif anim_name == "wipe_in":
			animation_player.play("wipe_out")
		in_transition_finished = false
	else:
		#print("Second half of transition complete")
		pass


