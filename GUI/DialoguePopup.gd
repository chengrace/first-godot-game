### DialogPopup.gd

extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var dialog_sound = $DialogueFX

signal dialog_finished

#gets the values of our npc from our NPC scene and sets it in the label values
#var npc_name : set = npc_name_set
var message: set = message_set
var response: set = response_set
var portrait: set = portrait_set

#reference to NPC
var npc

#no input on hidden
func _ready():
	set_process_input(false)
	
func _input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_A:  
				npc.dialog("A")
			elif event.keycode == KEY_B:
				npc.dialog("B")

func portrait_set(new_value):
	$Textbox/FacesetBox/Portrait.texture = new_value

#sets the npc name with the value received from NPC
#func npc_name_set(new_value):
	#npc_name = new_value
	#$Textbox/Name.text = new_value

#sets the message with the value received from NPC
func message_set(new_value):
	message = new_value
	$Textbox/Message.text = new_value

#sets the response with the value received from NPC
func response_set(new_value):
	response = new_value
	$Textbox/Response.text = new_value
	
#opens the dialog
func open():
	get_tree().paused = true
	self.visible = true
	dialog_sound.play()
	animation_player.play("typewriter")

#closes the dialog  
func close():
	get_tree().paused = false
	self.visible = false
	dialog_sound.play()
	dialog_finished.emit()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "typewriter":
		set_process_input(true)
