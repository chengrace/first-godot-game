## enemy.gd

extends CharacterBody2D

@onready var enemy_nav: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var grid = $GridMovement
@onready var start_walk_timer = $StartWalkingTimer
@onready var stop_walk_timer = $StopWalkingTimer
#@onready var end_point = %EnemyPath/endpoint
#@onready var start_point = %EnemyPath/startpoint
@export var start_point: Marker2D
@export var end_point: Marker2D
@export var speed = 0.4

var is_following = false
var direction = Vector2.ZERO
var target

func _ready():
	grid.speed = speed
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	animated_sprite.play("idle_down")
	target = end_point.position
 
func _process(_delta):
	if is_following:
	# follow player if close enough
		start_walk_timer.paused = true
		stop_walk_timer.paused = true
		target = %Player.global_position
		direction = global_position.direction_to(target)
	else:
	# enemy pathing
		#$StartWalkingTimer.paused = false
		print(position)
		print(enemy_nav.target_position)
		var next_path = enemy_nav.get_next_path_position()
		if next_path == enemy_nav.target_position:
			print("stop")
		if position == end_point.position:
			target = start_point.position
		elif position == start_point.position:
			target = end_point.position

		enemy_nav.target_position = target

		direction = (enemy_nav.get_next_path_position() - global_position).normalized()
	grid.move(direction)
	moving_animation(direction)
			
func moving_animation(input_direction: Vector2) -> void:
	var animation_state: StringName = animated_sprite.animation
	var moving_direction: Vector2 = grid.moving_direction
	var vectorDirection = vector2Direction(moving_direction)
	
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
	direction = Vector2.ZERO
	start_walk_timer.start()
	stop_walk_timer.stop()

func _on_start_walking_timer_timeout():
	stop_walk_timer.start()
	start_walk_timer.stop()

func _on_trigger_battle_radius_body_entered(body):
	#trigger battle scene
	print("trigger scene")
	get_tree().paused = true
