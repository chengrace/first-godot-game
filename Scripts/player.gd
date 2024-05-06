## player.gd

extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast = $GridMovement/RayCast2D

var health = 100
var direction
 
func _ready():
	if SceneManager.temp_save_data.has("player"):
		var data = SceneManager.temp_save_data["player"]
		if data.has("direction_facing"):
			animated_sprite.play("idle_" + data.direction_facing)
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	animated_sprite.play("idle_down")
	$UI/DialogPopup.visible = false
	$UI/PauseMenu.visible = false
	$UI/PauseMenu.resumed.connect(_on_resume)
	
func _input(event):
	if event.is_action_pressed("ui_action"):
		# Save game action
		var collision = ray_cast.get_collider()
		if collision != null:
			if collision.name == "SavePoint":
				SceneManager.is_saving = true
				SceneManager.change_scene_with_transition("res://Scenes/load_game.tscn")
			elif collision.is_in_group("npc"):
				$UI/DialogPopup.dialog_finished.connect(_on_dialog_finished)
				$UI/DimBackground.visible = true
				collision.dialog()
	elif event.is_action_pressed("escape"):
		if SceneManager.is_paused == false:
			$UI/DimBackground.visible = true
			$UI/PauseMenu.visible = true
			get_tree().paused = true
			SceneManager.is_paused = true
			$UI/PauseMenu.on_open()

func _on_resume():
	$UI/DimBackground.visible = false
	$UI/PauseMenu.visible = false
	get_tree().paused = false
		
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
	direction = "down"
	if vec.x > 0:
		animated_sprite.flip_h = true
		direction = "side" #facing right
	elif vec.x < 0:
		# Horizontal flip since we have one animation for both left and right walking and idle
		animated_sprite.flip_h = false
		direction = "side" #facing left
	elif vec.y > 0: direction = "down"
	elif vec.y < 0: direction = "up"
		
	return direction

func data_to_save():
	return {
		"position": [position.x, position.y],
		"health": health,
		"direction_facing": direction
	}
	
func data_to_load():
	var data = SceneManager.temp_save_data["player"]
	if data.has("position"):
		position = Vector2(data.position[0], data.position[1])

func _on_exit_area_body_entered(body):
	SceneManager.scene_changed.connect(_on_scene_changed)

#only after scene has been changed, do we free our resource     
func _on_scene_changed():
	queue_free()
	
func _on_dialog_finished():
	$UI/DimBackground.visible = false
