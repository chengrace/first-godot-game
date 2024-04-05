### DialogPopup.gd

extends CanvasLayer

#gets the values of our npc from our NPC scene and sets it in the label values
var npc_name : set = npc_name_set
var message: set = message_set
var response: set = response_set

#reference to NPC
var npc

#sets the npc name with the value received from NPC
func npc_name_set(new_value):
	npc_name = new_value
	$Dialog/NPC.text = new_value

#sets the message with the value received from NPC
func message_set(new_value):
	message = new_value
	$Dialog/Message.text = new_value

#sets the response with the value received from NPC
func response_set(new_value):
	response = new_value
	$Dialog/Response.text = new_value
