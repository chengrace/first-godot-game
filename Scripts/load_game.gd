#load_game.gd

extends Node2D

@onready var save1_title = $ColorRect/Save1/CurrentScene
@onready var save1_timestamp = $ColorRect/Save1/Timestamp
@onready var save1_no_save = $ColorRect/Save1/NoSaveFile
@onready var save2_title = $ColorRect/Save2/CurrentScene
@onready var save2_timestamp = $ColorRect/Save2/Timestamp
@onready var save2_no_save = $ColorRect/Save2/NoSaveFile
@onready var first_button = $ColorRect/Save1
@onready var button_sound = $ButtonSound

var skip_first_button_sound = false #true when completed

func _ready():
	skip_first_button_sound = false
	first_button.grab_focus()
	if !read_from_save_files(Constants.SAVE_PATH_1, save1_title, save1_timestamp):
		save1_no_save.visible = true
	if !read_from_save_files(Constants.SAVE_PATH_2, save2_title, save2_timestamp):
		save2_no_save.visible = true

func _input(event):
	if event.is_action("ui_back"):
		var previous_scene = "res://Scenes/" + SceneManager.current_scene_filename
		SceneManager.change_scene(previous_scene)

func read_from_save_files(save_path, save_title, save_timestamp):
	if FileAccess.file_exists(save_path):
		#print("Save file found!")
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		# Load the saved scene
		if !data.has("saved_at_scene") or !data.has("timestamp"):
			print(data)
			return false
		else:
			save_title.text = data["saved_at_scene"]
			save_timestamp.text = Time.get_datetime_string_from_datetime_dict(data["timestamp"], true)
			return true
	else:
		return false

func _on_save_1_pressed():
	if SceneManager.is_saving:
		SceneManager.save(Constants.SAVE_PATH_1)
		print("Saving game 1...")
		await "save_completed"
	SceneManager.loading = true
	SceneManager.load_game(Constants.SAVE_PATH_1)
	print("Loading game 1...")
	queue_free()

func _on_save_2_pressed():
	if SceneManager.is_saving:
		SceneManager.save(Constants.SAVE_PATH_2)
		print("Saving game 2...")
		await "save_completed"
	SceneManager.loading = true
	SceneManager.load_game(Constants.SAVE_PATH_2)
	print("Loading game 2...")
	queue_free()
	
func _on_save_1_focus_entered():
	if skip_first_button_sound:
		button_sound.play()
	else:
		skip_first_button_sound = true

func _on_save_2_focus_entered():
	button_sound.play()
