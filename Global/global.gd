## global.gd 

extends Node

signal scene_changed(new_scene)

var save_path = "/Users/gracechen/desktop/phone_game_save.json" # you will need to manually change this line for your own PC 
var current_scene_name
var loading = false

#set current scene on load
func _ready():
	current_scene_name = get_tree().get_current_scene().name

# Saves game at current scene.
func save():
	var current_scene = get_tree().get_current_scene()
	if current_scene != null:
		current_scene_name = current_scene.name
		var data = { 
			"scene_name" : current_scene_name,
			"scene_filename": current_scene.scene_file_path.get_file()
		}
		if current_scene.has_node("Player"):
			var player = get_tree().get_root().get_node("%s/Player" % current_scene_name)
			print("Player exists: ", player != null)
			data["player"] = player.data_to_save()  
		# converts dictionary (data) into json
		var json = JSON.new()
		var to_json = json.stringify(data)
		# opens save file for writing
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		# writes to save file
		file.store_line(to_json)
		# close the file
		file.close()
	else:
		print("No active scene. Cannot save.")

func change_scene(scene_path):
	save()
	# Get the current scene
	current_scene_name = scene_path.get_file().get_basename()
	var current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	# Free it for the new scene
	current_scene.queue_free()
	# Change the scene
	var new_scene = load(scene_path).instantiate()
	get_tree().get_root().call_deferred("add_child", new_scene) 
	get_tree().call_deferred("set_current_scene", new_scene)    
	call_deferred("post_scene_change_initialization")
	
func load_game():
	if loading and FileAccess.file_exists(save_path):
		print("Save file found!")
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		# Load the saved scene
		var scene_path = "res://Scenes/%s" % data["scene_filename"]
		print("Scene_path:", scene_path)
		var game_resource = load(scene_path)
		var game = game_resource.instantiate()
		# Change to the loaded scene
		get_tree().root.call_deferred("add_child", game)        
		get_tree().call_deferred("set_current_scene", game)
		current_scene_name = game.name
		# Now you can load data into the nodes
		var player = game.get_node("Player")    
		#checks if they are valid before loading their data
		if player:
			player.data_to_load(data["player"])
	else:
		print("Save file not found!")
	loading = false
	

func post_scene_change_initialization():
	scene_changed.emit()
