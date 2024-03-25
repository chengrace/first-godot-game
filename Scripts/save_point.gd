# save_point.gd
extends RigidBody2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("default")

#func _input(event):
	#if event.is_action_pressed("ui_attack"):
		#print("trigger save scene")
