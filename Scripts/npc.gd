## npc.gd

extends CharacterBody2D

@onready var ray_cast = $GridMovement/RayCast2D

func _ready():
	# changes collision masks for npc
	ray_cast.set_collision_mask_value(1, true)
	ray_cast.set_collision_mask_value(2, true)
	ray_cast.set_collision_mask_value(3, true)
	# npc will bump into everything if it tries to walk in that direction

