## player.gd

extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
 
func _ready():
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	animated_sprite.play("idle_down")
 
func _process(_delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	$GridMovement.move(input_direction)
	moving_animation(input_direction)
			
func moving_animation(input_direction: Vector2) -> void:
	var animation_state: StringName = animated_sprite.animation
	var moving_direction: Vector2 = $GridMovement.moving_direction
	var vectorDirection = vector2Direction(moving_direction)
	
	if moving_direction.length() > 0:
		animation_state = "walk_" + vectorDirection
	else:
		if input_direction.length() > 0:
			vectorDirection = vector2Direction(input_direction)
			animation_state = "idle_" + vectorDirection
		else:
			vectorDirection = animation_state.get_slice("_", 1)
			animation_state = "idle_" + vectorDirection
			
	animated_sprite.play(animation_state)
 
func vector2Direction(vec: Vector2) -> String:
	var direction = "down"
	if vec.y > 0: direction = "down"
	elif vec.y < 0: direction = "up"
	elif vec.x > 0:
		animated_sprite.flip_h = true
		direction = "side" #facing right
	elif vec.x < 0:
		# Horizontal flip since we have one animation for both left and right walking and idle
		animated_sprite.flip_h = false
		direction = "side" #facing left
		
	return direction
