## npc.gd

extends CharacterBody2D

@onready var dialog_popup = %Player/UI/DialogPopup
@onready var player = %Player
@onready var ray_cast = $GridMovement/RayCast2D
@onready var animation_sprite = $AnimatedSprite2D
@onready var sprite_texture = load("res://Assets/NPC/contentfrognpc.png")

@export var npc_name = ""

var dialog_state = 0

func _ready():
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	animation_sprite.play("idle_down")
	# changes collision masks for npc
	ray_cast.set_collision_mask_value(1, true)
	ray_cast.set_collision_mask_value(2, true)
	ray_cast.set_collision_mask_value(3, true)
	# npc will bump into everything if it tries to walk in that direction

func dialog(response = ""):
	# Set our NPC's animation to "talk"
	#animation_sprite.play("talk_down")
	animation_sprite.play("idle_down")
	
	# Set dialog_popup npc to be referencing this npc
	dialog_popup.npc = self
	dialog_popup.npc_name = str(npc_name)
	dialog_popup.portrait = sprite_texture
	
	# dialog tree
	match dialog_state:
		0:
			# Update dialog tree state
			dialog_state = 1
			# Show dialog popup
			dialog_popup.message = "Hey partner, have a minute to spare?"
			dialog_popup.response = "[A] Yes  [B] No"
			dialog_popup.open() #re-open to show next dialog
		1:
			match response:
				"A":
					# Update dialog tree state
					dialog_state = 2
					# Show dialog popup
					dialog_popup.message = "Good, because I need your help finding my coffin key."
					dialog_popup.response = "[A] Bye"
					dialog_popup.open() #re-open to show next dialog
				"B":
					# Update dialog tree state
					dialog_state = 3
					# Show dialog popup
					dialog_popup.message = "Well, I didn't like your face anyway."
					dialog_popup.response = "[A] Bye"
					dialog_popup.open() #re-open to show next dialog
		2:
			# Update dialog tree state
			dialog_state = 0
			# Close dialog popup
			dialog_popup.close()
			# Set NPC's animation back to "idle"
			animation_sprite.play("idle_down")
		3:
			# Update dialog tree state
			dialog_state = 0
			# Close dialog popup
			dialog_popup.close()
			# Set NPC's animation back to "idle"
			animation_sprite.play("idle_down")
