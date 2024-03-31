## follow_cam.gd

extends Camera2D

@export var tilemap: TileMap

func _ready():
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_top = 0
	limit_left = 0
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
