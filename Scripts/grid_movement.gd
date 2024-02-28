extends Node2D
 
@onready var self_node = get_tree().get_root().get_node("Main/Player")
@export var speed: float = 0.3

var moving_direction: Vector2 = Vector2.ZERO
 
func move(direction: Vector2) -> void:
	if moving_direction.length() == 0 && direction.length() > 0:
		var movement = Vector2.DOWN
		if direction.y > 0: movement = Vector2.DOWN
		elif direction.y < 0: movement = Vector2.UP
		elif direction.x > 0: movement = Vector2.RIGHT
		elif direction.x < 0: movement = Vector2.LEFT
		
		moving_direction = movement
		print(self_node)
		var new_position = self_node.global_position + (moving_direction * Constants.TILE_SIZE)
		
		var tween = create_tween()
		tween.tween_property(self_node, "position", new_position, speed).set_trans(Tween.TRANS_LINEAR)
		tween.tween_callback(func(): moving_direction = Vector2.ZERO)
