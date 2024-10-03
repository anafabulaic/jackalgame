extends Node

@export var current_camera: Camera3D
@export var current_room: Room
@export var current_view: RoomView
@export var current_background: Sprite2D
@export var fader_ref: ColorRect
@export var document_canvas: DocumentCanvas

var drawing_canvas: Node2D

var room_list: Dictionary
var room_names: Array

func _ready() -> void:
	LimboConsole.register_command(load_room, "load_room", "loads a room")
	LimboConsole.register_command(dump_room_list, "dump_room_list", "lists rooms")
	LimboConsole.register_command(set_position, "set_position", "sets your position")
	LimboConsole.add_argument_autocomplete_source("load_room", 1, func() -> Array: return room_names)

func wait(seconds: float) -> Signal:
	return get_tree().create_timer(seconds).timeout
	
func initialize_view(view: RoomView) -> void:
	if not view:
		return
	current_view = view
	
	set_camera_params(current_view.get_camera_position(), current_view.get_camera_rotation(), current_view.camera_fov, current_view.camera_near, current_view.camera_far)
	
	RenderingServer.global_shader_parameter_set("depth_pass", current_view.depth_map)
	current_background.texture = current_view.background_image
	
func initialize_room(room: PackedScene, view: int = 0) -> void:
	if room == null:
		print("Error, couldn't get room!")
		return
	if room.instantiate() is not Room:
		print("Tried to initialize something that isn't a Room")
		return
	if current_room != null:
		current_room.destroy()
	current_room = room.instantiate()
	add_child(current_room)
	initialize_view(current_room.views[view])

func initialize_room_transition(transition: PackedScene, scene_ref: SceneReference, room_landing: Vector3 = Vector3(0,0,0), landing_rotation: float = 0.0, view: int = 0) -> void:
	if not RoomTransition:
		return
		
	var landing: Vector3 = room_landing
	var transition_scene: RoomTransition = transition.instantiate()
	var destination: PackedScene = load(scene_ref.scene)
	
	PlayerManager.set_player_state(PlayerManager.PLAYER_IN_SCENE_TRANSITION)
	
	fade_camera(false, 0.5)
	await fader_ref.fade_done
	
	add_child(transition_scene)

	await transition_scene.transition_midpoint
	
	initialize_room(destination)
	
	await transition_scene.transition_finished
	
	transition_scene.destroy()
	PlayerManager.player_ref.position = landing
	PlayerManager.player_ref.rotation.y = deg_to_rad(landing_rotation)
	
	fade_camera(true, 0.5)
	await fader_ref.fade_done
	
	PlayerManager.set_player_state(PlayerManager.PLAYER_READY)
	
func set_camera_params(cam_position: Vector3, cam_rotation: Vector3, cam_fov: float, cam_near: float = 0.05, cam_far: float = 4000.0) -> void:
	current_camera.position = cam_position
	current_camera.rotation = cam_rotation
	current_camera.fov = cam_fov
	current_camera.set_near(cam_near)
	current_camera.set_far(cam_far)
	
func fade_camera(in_or_out: bool = true, seconds: float = 3.0) -> void:
	if in_or_out:
		fader_ref.fade_in(seconds)
	else:
		fader_ref.fade_out(seconds)

func initialize_document(document: Document, do_fade: bool) -> void:
	if document_canvas == null or document == null:
		return
	if do_fade == true:
		Global.fade_camera(false, 0.25)
		await Global.fader_ref.fade_done
	
	PlayerManager.player_state = PlayerManager.PLAYER_IN_INSPECTING
	
	document_canvas.document_fade_in(1.0)
	document_canvas.set_document(document)

func get_all_files(path: String, file_ext := "", files: Dictionary = {}) -> Dictionary:
	var dir: DirAccess = DirAccess.open(path)
	print("Opened ", dir)
	if dir:
		dir.list_dir_begin()

		var file_name: String = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				files = get_all_files(dir.get_current_dir() + "/" + file_name, file_ext, files)
			else:
				print("Got here 1 and file_name is ", file_name)
				if file_ext and file_name.get_extension() and file_name.trim_suffix(".remap").get_extension() != file_ext:
					file_name = dir.get_next()
					continue
				if file_name.get_extension() == "remap":
					file_name = file_name.trim_suffix(".remap")
					print("Got here 3")
				print("File name is ", file_name)
				files[file_name] = dir.get_current_dir() + "/" + file_name

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s." % path)

	return files

func populate_room_list() -> void:
	room_list = get_all_files("res://rooms/", "tscn")
	for key: String in room_list.keys():
		print("Obtained ", key)
		room_names.append(key.trim_suffix(".tscn"))
	
func load_room(room_name: String) -> void:
	if room_list.has(room_name + ".tscn") and room_list[room_name + ".tscn"]:
		var room: PackedScene = load(room_list[room_name  + ".tscn"])
		if room.instantiate() is not Room:
			LimboConsole.info("Failed to load room -- tried to load something that isn't a room.")
			return
		initialize_room(room)
	else:
		LimboConsole.info("Failed to load room -- couldn't find room.")

func dump_room_list() -> void:
	if room_names == null or room_names.size() == 0:
		LimboConsole.info("No rooms in room list.")
		return
	for room: String in room_names:
		LimboConsole.info(room)

func set_position(x_pos: float = 0.0, y_pos: float = 0.0, z_pos: float = 0.0) -> void:
	if PlayerManager.player_ref != null:
		PlayerManager.player_ref.position = Vector3(x_pos, y_pos, z_pos)
