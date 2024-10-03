extends Node
class_name RoomView

@export var background_image: Texture2D
@export var depth_map: Texture2D

# Copy the data from Blender
@export var camera_position: Vector3
@export var camera_rotation: Vector3
@export var camera_fov: float

# Copy depth pass compositor data
@export var camera_near: float
@export var camera_far: float

@export var roomview_thresholds: Array[RoomThreshold]

@export var numina_view: RoomView
@export var view_is_numina: bool = false

# Gets corrected Blender camera position
func get_camera_position() -> Vector3:
	var corrected_position: Vector3 = Vector3(\
		camera_position.x,\
		camera_position.z,\
		-camera_position.y\
	)
	return corrected_position

# Gets corrected Blender camera rotation
func get_camera_rotation() -> Vector3:
	var corrected_rotation: Vector3 = Vector3(\
		deg_to_rad(camera_rotation.x - 90.0),\
		deg_to_rad(camera_rotation.z),\
		deg_to_rad(-camera_rotation.y)\
	)
	return corrected_rotation
