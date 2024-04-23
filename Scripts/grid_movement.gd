## grid_movement.gd

extends Node2D
 
@export var self_node: Node2D
@export var speed: float = 0.3
 
var moving_direction: Vector2 = Vector2.ZERO
 
func _ready():
	# Set movement direction as DOWN by default
	$RayCast2D.target_position = Vector2.DOWN * Constants.TILE_SIZE

# Use when vector isn't clearly one direction. 
func fix_vector(vec: Vector2):
	if abs(vec.x) > abs(vec.y):
		if vec.x < 0:
			vec.x = -1
		else:
			vec.x = 1
		vec.y = 0
	if abs(vec.y) >= abs(vec.x):
		if vec.y < 0:
			vec.y = -1
		else:
			vec.y = 1
		vec.x = 0 
		#prioritize up and down over left and right movement
	return vec
 
func move(direction: Vector2) -> void:
	if moving_direction.length() == 0 && direction.length() > 0:
		var movement = Vector2.DOWN
		if direction.y > 0: movement = Vector2.DOWN
		elif direction.y < 0: movement = Vector2.UP
		elif direction.x > 0: movement = Vector2.RIGHT
		elif direction.x < 0: movement = Vector2.LEFT
		
		$RayCast2D.target_position = movement * Constants.TILE_SIZE
		$RayCast2D.force_raycast_update() # Update the `target_position` immediately
		
		# Allow movement only if no collision in next tile or if the collider is just its own node:
		var collision = $RayCast2D.get_collider()
		#if collision is TileMap:
			#print(collision.get_cell_tile_data())
			#print(collision.get_coords_for_body_rid(collision))
			#print(collision.get_layer_name())

		if collision == null or collision.is_in_group("player"):
			moving_direction = movement
			
			var new_position = self_node.global_position + (moving_direction * Constants.TILE_SIZE)
			
			var tween = create_tween()
			tween.tween_property(self_node, "position", new_position, speed).set_trans(Tween.TRANS_LINEAR)
			tween.tween_callback(func(): moving_direction = Vector2.ZERO)
