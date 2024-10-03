@tool
extends InteractiveArea3D
class_name RoomThreshold

@export var view_destination: RoomView

func _ready() -> void:
	connect("body_shape_entered", _on_body_shape_entered)

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if view_destination and Global.current_view != view_destination and body is Player:
		Global.initialize_view(view_destination)
