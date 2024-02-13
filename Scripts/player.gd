extends CharacterBody2D

# Node references
@onready var animation_sprite = $AnimatedSprite2D

#direction and animation to be updated throughout game state
var new_direction = Vector2(0,1) #only move one spaces
var animation

# Player states
@export var speed = 200
var is_attacking = false

func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		var animation = "attack_" + returned_direction(new_direction)
		animation_sprite.play(animation)	

func _physics_process(delta):
	# Player basic movement, no diagonal
	var direction: Vector2
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		direction.y = 0
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
		direction.y = 0
	elif Input.is_action_pressed("ui_up"):
		direction.x = 0
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.x = 0
		direction.y = 1
	else: 
		direction.x = 0
		direction.y = 0
	
	# Sprinting
	if Input.is_action_pressed("ui_sprint"):
		speed = 100 
	elif Input.is_action_just_released("ui_sprint"):
		speed = 50
	
	var movement = speed * direction * delta
	
	if is_attacking == false:
		move_and_collide(movement)
		player_animations(direction)

func player_animations(direction: Vector2):
	#Vector2.ZERO = (0,0)
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "walk_" + returned_direction(new_direction)
		animation_sprite.play(animation)
	else:
		#animation = "idle_" + returned_direction(new_direction)
		animation = "idle"
		animation_sprite.play(animation)

func returned_direction(direction: Vector2):
	var normalized_direction = direction.normalized()
	var default_return = "side"
	
	#print(normalized_direction)
	
	if normalized_direction.y >= 1:
		# vector is (0, 1)
		return "down"
		
	elif normalized_direction.y <= -1:
		# vector is (0,-1)
		return "up"
	elif normalized_direction.x >= 1:
		#left
		# vector is (-1,0)
		animation_sprite.flip_h = false
		return "side"
	elif normalized_direction.x <= -1:
		#right
		# vector is (1,0)
		animation_sprite.flip_h = true
		return "side"
	else:
		if Input.is_action_pressed("ui_left"):
			animation_sprite.flip_h = true
		elif Input.is_action_pressed("ui_right"):
			animation_sprite.flip_h = false
			
		
		return default_return


func _on_animated_sprite_2d_animation_finished():
	is_attacking = false

