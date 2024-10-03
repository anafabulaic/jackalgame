@tool
extends InteractiveArea3D
class_name RoomInspectable

@export var inspectable_resource: Document

func do_interact() -> void:
	Global.initialize_document(inspectable_resource, true)
