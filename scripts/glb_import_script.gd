@tool
extends EditorScenePostImport

# Dictionary variable for get_all_files
var image_list: Dictionary

func _post_import(scene: Node) -> Object:
	image_list = get_all_files(get_source_file().get_base_dir(), "png")
	for child in scene.get_children():
		process(child)
	return scene

func process(node) -> void:
	if node != null:
		if node is Camera3D:
			var camera: Camera3D = node
			var new_view: RoomView = RoomView.new()
			var rotate_helper: Node3D = Node3D.new()
			var camera_name: String = camera.name
			
			var bg_path = get_source_file().get_base_dir() + "/" + camera.owner.name + "_" + camera.name.to_lower() + "_bg.png"
			var depth_path = get_source_file().get_base_dir() + "/" + camera.owner.name + "_" + camera.name.to_lower() + "_depth.png"
			var depth_image = ImageTexture.new()
			
			new_view.camera_position = Vector3(camera.position.x, -camera.position.z, camera.position.y)
			new_view.camera_rotation = Vector3(camera.rotation.x + deg_to_rad(90.0), -camera.rotation.z, camera.rotation.y)
			new_view.camera_rotation = Vector3(rad_to_deg(new_view.camera_rotation.x), rad_to_deg(new_view.camera_rotation.y), rad_to_deg(new_view.camera_rotation.z))

			new_view.camera_near = camera.near
			new_view.camera_far = camera.far
			new_view.camera_fov = rad_to_deg(2 * atan(tan(deg_to_rad(camera.fov) / 2) * 4/3))
						
			new_view.background_image = load(bg_path)
			new_view.depth_map = depth_image.create_from_image(load(depth_path))
			
			if new_view.background_image == null:
				push_error("Tried to load invalid background image.")
			elif new_view.depth_map == null:
				push_error("Tried to load invalid depth image.")

			camera.owner.add_child(new_view)
			new_view.set_owner(camera.owner)
			new_view.set_name("Room" + camera_name)
			
			rotate_helper.transform = camera.transform
			rotate_helper.name = "RotateHelper"
			new_view.add_child(rotate_helper)
			rotate_helper.set_owner(new_view.owner)
			
			for child in camera.get_children():
				if child != null and child is MeshInstance3D and child.name.contains("Threshold"):
					var mesh: MeshInstance3D = child
					var mesh_aabb: AABB = mesh.mesh.get_aabb()
					var new_threshold: RoomThreshold = RoomThreshold.new()
					
					rotate_helper.add_child(new_threshold)
					new_threshold.set_name(new_view.name + "Threshold")
					new_threshold.set_owner(rotate_helper.owner)
					
					new_threshold.area_size = mesh_aabb.size
					new_threshold.transform = mesh.transform
					new_threshold.view_destination = new_view
					
					mesh.queue_free()
			camera.queue_free()
		elif node is MeshInstance3D and not node.name.contains("Threshold"):
			var mesh: MeshInstance3D = node
			mesh.create_trimesh_collision()
			mesh.visible = false

func get_all_files(path: String, file_ext := "", files: Dictionary = {}) -> Dictionary:
	var dir: DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()

		var file_name: String = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				files = get_all_files(dir.get_current_dir() + "/" + file_name, file_ext, files)
			else:
				if file_ext and file_name.get_extension() and file_name.trim_suffix(".remap").get_extension() and file_name.trim_suffix(".import").get_extension() != file_ext:
					file_name = dir.get_next()
					continue
				if file_name.get_extension() == "remap":
					file_name = file_name.trim_suffix(".remap")
				elif file_name.get_extension() == "import":
					file_name = file_name.trim_suffix(".import")
				files[file_name] = dir.get_current_dir() + "/" + file_name

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s." % path)

	return files
