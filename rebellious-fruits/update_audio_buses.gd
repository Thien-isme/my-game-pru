@tool
extends SceneTree

func _init():
	var dir = DirAccess.open("res://scenes")
	if dir:
		_process_dir(dir, "res://scenes")
	quit()

func _process_dir(dir: DirAccess, path: String):
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir() and not file_name.begins_with("."):
			var sub_path = path + "/" + file_name
			var sub_dir = DirAccess.open(sub_path)
			if sub_dir:
				_process_dir(sub_dir, sub_path)
		elif file_name.ends_with(".tscn"):
			_modify_scene(path + "/" + file_name)
		file_name = dir.get_next()

func _modify_scene(file_path: String):
	var scene = ResourceLoader.load(file_path, "PackedScene")
	if scene:
		var instance = scene.instantiate()
		var changed = false
		changed = _assign_bus(instance) or changed
		if changed:
			# Resave the scene
			var modified_scene = PackedScene.new()
			modified_scene.pack(instance)
			ResourceSaver.save(modified_scene, file_path)
			print("Updated scene: ", file_path)
		instance.queue_free()

func _assign_bus(node: Node) -> bool:
	var changed = false
	if node is AudioStreamPlayer:
		if node.bus != "SFX":
			node.bus = "SFX"
			changed = true
	
	for child in node.get_children():
		changed = _assign_bus(child) or changed
		
	return changed
