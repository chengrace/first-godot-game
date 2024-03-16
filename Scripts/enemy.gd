## enemy.gd

extends CharacterBody2D

@onready var enemy_nav: NavigationAgent2D = $NavigationAgent2D

@export var speed = 0.4
var is_following = false
var direction = Vector2.ZERO
var movements = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$GridMovement.speed = speed
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	$AnimatedSprite2D.play("walk_side") #todo: change to idle_down after animation sheet is added
	#play("idle_down")
 
func _process(_delta):
	if is_following:
	# follow player if close enough
		$StartWalkingTimer.paused = true
		$StopWalkingTimer.paused = true
		direction = global_position.direction_to(%Player.global_position)
	else:
	# randomized walking
		#$StartWalkingTimer.paused = false
		enemy_nav.target_position = get_global_mouse_position()
		direction = (enemy_nav.get_next_path_position() - global_position).normalized()
	$GridMovement.move(direction)
	moving_animation(direction)
			
func moving_animation(input_direction: Vector2) -> void:
	var animation_state: StringName = $AnimatedSprite2D.animation
	var moving_direction: Vector2 = $GridMovement.moving_direction
	var vectorDirection = vector2Direction(moving_direction)
	
	if moving_direction.length() > 0:
		pass
		#animation_state = "walk_" + vectorDirection
	else:
		if input_direction.length() > 0:
			vectorDirection = vector2Direction(input_direction)
			#animation_state = "idle_" + vectorDirection
		else:
			vectorDirection = animation_state.get_slice("_", 1)
			#animation_state = "idle_" + vectorDirection
			
	$AnimatedSprite2D.play(animation_state)
 
func vector2Direction(vec: Vector2) -> String:
	var direction = "down"
	if vec.y > 0: direction = "down"
	elif vec.y < 0: direction = "up"
	elif vec.x > 0:
		$AnimatedSprite2D.flip_h = false
		direction = "side"
	elif vec.x < 0:
		# Horizontal flip since we have one animation for both left and right walking and idle
		$AnimatedSprite2D.flip_h = true
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
	$StartWalkingTimer.start()
	$StopWalkingTimer.paused = true

func _on_start_walking_timer_timeout():
	$StopWalkingTimer.start()
	$StartWalkingTimer.paused = true

func _on_trigger_battle_radius_body_entered(body):
	#trigger battle scene
	print("trigger scene")
	get_tree().paused = true
