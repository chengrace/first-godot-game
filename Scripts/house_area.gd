##house_area.gd

extends Node2D

@onready var animation_player = $Transition

func _ready():
	animation_player.play("fade_in")
	
