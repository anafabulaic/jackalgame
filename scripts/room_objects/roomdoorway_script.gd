@tool
extends InteractiveArea3D
class_name RoomDoorway

@export var room_destination: SceneReference
@export var room_destination_landing: Vector3
@export var room_destination_landing_rotation: float
@export var room_destination_landing_view: int
@export var room_transition: PackedScene

@export var doorway_locked: bool
@export var doorway_keys: Array[ItemKey]
@export var doorway_numina: bool

func do_interact() -> void:
	Global.initialize_room_transition(room_transition, room_destination, room_destination_landing, room_destination_landing_rotation, room_destination_landing_view)
