extends Node2D

@onready var bgm = $BGM

func _ready():
	bgm.play()
