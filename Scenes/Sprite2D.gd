extends Sprite2D

@onready var bee_follow = %BeeFollow

func _process(delta):
	bee_follow.progress_ratio += 0.0005
