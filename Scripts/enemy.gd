## enemy.gd

extends CharacterBody2D

@onready var enemy_nav: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var grid = $GridMovement
@onready var start_walk_timer = $StartWalkingTimer
@onready var stop_walk_timer = $StopWalkingTimer
@onready var bee_path = %BeePath
@export var speed = 0.8

var is_following = false
var direction = Vector2.ZERO
var curr_path_index = 0
var is_reverse_path = false
var next_pos

func _ready():
	grid.speed = speed
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	animated_sprite.play("idle_down")
 
func _process(_delta):
	if is_following:
	# follow player if close enough
		start_walk_timer.paused = true
		stop_walk_timer.paused = true
		grid.speed = 0.35
		direction = global_position.direction_to(%Player.global_position)
	else:
	# enemy pathing
		if start_walk_timer.is_stopped():
			direction = Vector2.ZERO
		else:
		#follow along the path
			grid.speed = speed
			next_pos = next_point_on_path(bee_path)
			direction = global_position.direction_to(next_pos)
			print(next_pos)
	grid.move(direction)
	moving_animation(direction)

func next_point_on_path(path_node):
	# reverses order of path when reaching the end point
	if curr_path_index == path_node.curve.point_count - 1:
		is_reverse_path = true
	if curr_path_index == 0:
		is_reverse_path = false
		
	if is_reverse_path:
		curr_path_index -= 1
	if !is_reverse_path:
		curr_path_index +=1
		
	return path_node.curve.get_point_position(curr_path_index)
			
func moving_animation(input_direction: Vector2) -> void:
	var animation_state: StringName = animated_sprite.animation
	var moving_direction: Vector2 = grid.moving_direction
	var vectorDirection = vector2Direction(moving_direction)
	
	#print(vectorDirection)
	if moving_direction.length() > 0:
		pass
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
		animated_sprite.flip_h = false
		direction = "side"
	elif vec.x < 0:
		# Horizontal flip since we have one animation for both left and right walking and idle
		animated_sprite.flip_h = true
		direction = "side"
	
	return direction

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		is_following = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		is_following = false

func _on_stop_timer_timeout():
	start_walk_timer.start()
	stop_walk_timer.stop()

func _on_start_walking_timer_timeout():
	stop_walk_timer.start()
	start_walk_timer.stop()

func _on_trigger_battle_radius_body_entered(body):
	#trigger battle scene
	print("trigger scene")
	get_tree().paused = true
