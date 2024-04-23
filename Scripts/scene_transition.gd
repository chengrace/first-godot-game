## scene_transition.gd

extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var color_transition = $DissolveRect
@onready var circle_shader = $CircleShader

signal anim_in_finished

func _ready():
	#color_transition.modulate.a = 0
	#circle_shader.modulate.a = 0
	color_transition.size = Vector2(480, 360)
	circle_shader.size = Vector2(480, 360)

func play_transition(transition, color):
	if transition == "none":
		anim_in_finished.emit()
	else:
		circle_shader.color = color
		color_transition.color = color
		if transition == "dissolve" :
			run_transition("dissolve", "dissolve", true)
		elif transition == "wipe":
			run_transition("wipe_in", "wipe_out")
		elif transition == "intro":
			run_transition("dissolve", "circle_open")

func run_transition(anim1, anim2, backwards=false):
	animation_player.play(anim1)
	await animation_player.animation_finished
	anim_in_finished.emit() # to change scene in global.gd
	await Global.scene_changed
	if backwards:
		animation_player.play_backwards(anim2)
	else:
		animation_player.play(anim2)
