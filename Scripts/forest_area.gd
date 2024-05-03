##forest_area.gd

extends Node2D

func _ready():
	$BGM.play()
	if SceneManager.temp_save_data.has("scene_filename"):
		if SceneManager.temp_save_data["scene_filename"] == "house_area.tscn":
			$Player.position = Vector2(100,130)
		elif SceneManager.temp_save_data["scene_filename"] == "load_game.tscn":
			$Player.data_to_load()
	else:
		$Player.position = Vector2(400,200)

#only after scene has been changed, do we free our resource     
func _on_scene_changed():
	queue_free()

func _on_house_area_enter_body_entered(body):
	if body.is_in_group("player"):
		SceneManager.change_scene_with_transition("res://Scenes/house_area.tscn")
		SceneManager.scene_changed.connect(_on_scene_changed)
