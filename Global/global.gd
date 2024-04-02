## global.gd 

extends Node

signal scene_changed(new_scene)
signal save_completed

var current_scene_name
var current_scene_filename
var new_scene_path
var loading = false
var is_saving = false # toggles whether screen is for saving or loading game
var data = {}

# Saves game at current scene.
func save(save_path):
	data["timestamp"] = Time.get_datetime_dict_from_system()
	# converts dictionary (data) into json
	var json = JSON.new()
	var to_json = json.stringify(data)
	# opens save file for writing
	# var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, Constants.encryption_password)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	# writes to save file
	file.store_line(to_json)
	# close the file
	file.close()
	emit_signal("save_completed")
	print("Successfully saved.")
	
func load_game(save_path):
	if loading and FileAccess.file_exists(save_path):
		print("Save file found!")
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		# Load the saved scene
		var scene_path = "res://Scenes/%s" % data["scene_filename"]
		#print("Scene_path:", scene_path)
		var game_resource = load(scene_path)
		var game = game_resource.instantiate()
		# Change to the loaded scene
		get_tree().root.call_deferred("add_child", game)        
		get_tree().call_deferred("set_current_scene", game)
		# Now you can load data into the nodes
		var player = game.get_node("Player")    
		#checks if they are valid before loading their data
		if player:
			player.data_to_load(data["player"])
	else:
		print("Save file not found!")
	loading = false
	
func change_scene_with_transition(new_scene, transition_name="none", color="LAVENDER_BLUSH"):
	new_scene_path = new_scene
	SceneTransition.play_transition(transition_name, color)
	SceneTransition.anim_in_finished.connect(_on_anim_in_finished)
	
# Wait for signal of first half of transition before changing our scene.
func _on_anim_in_finished():
	self.change_scene(new_scene_path)
	
func change_scene(new_scene_path):
	var current_scene = get_tree().get_current_scene()
	current_scene_name = current_scene.name
	current_scene_filename = current_scene.scene_file_path.get_file()
	# Get the current scene
	if current_scene != null:
		data["scene_name"] = current_scene_name
		data["scene_filename"] = current_scene_filename
		if current_scene.has_node("Player"):
			var player = get_tree().get_root().get_node("%s/Player" % current_scene.name)
			print("Player exists: ", player != null)
			data["player"] = player.data_to_save()
	# Free it for the new scene
	current_scene.queue_free()
	# Change the scene
	var new_scene = load(new_scene_path).instantiate()
	get_tree().get_root().call_deferred("add_child", new_scene) 
	get_tree().call_deferred("set_current_scene", new_scene)    
	call_deferred("post_scene_change_initialization")
	
#only after scene has been changed, do we free our resource     
func post_scene_change_initialization():
	scene_changed.emit()


