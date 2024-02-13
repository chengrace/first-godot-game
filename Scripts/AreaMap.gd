extends Area2D

var tile_size = 64 # should match size of tiles
var inputs = {"ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT, "ui_up": Vector2.UP, "ui_down": Vector2.DOWN}

#initializing position variables
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	# snapped allows us to round position to nearest tile increment
	# and adding a half-tile amount to make sure 
	# the player is centered on the tile
	position += Vector2.ONE * tile_size/2
	
func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
			
func move(dir):
	position += inputs[dir] * tile_size
	
