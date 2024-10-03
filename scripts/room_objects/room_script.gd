extends Node3D
class_name Room

@export var room_name: String

@export var room_enemies: Enemy
@export var room_items: Item
@export var room_stats: Dictionary

@export var room_is_numina: bool = false
@export var numina_room: Room

var views: Array[RoomView]
var doorways: Array[RoomDoorway]
var enemies: Array[Enemy]
var room_mesh: MeshInstance3D

func _ready() -> void:
	populate_children()
	room_mesh.visible = false

func populate_children() -> void:
	for child in get_children():
		if child is MeshInstance3D:
			room_mesh = child
		elif child is RoomView:
			views.append(child)
		elif child is RoomDoorway:
			doorways.append(child)
		elif child is Enemy:
			enemies.append(child)

func destroy() -> void:
	queue_free()
