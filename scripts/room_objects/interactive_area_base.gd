@tool
extends Area3D
class_name InteractiveArea3D

@export var area_size: Vector3 = Vector3(1.0,1.0,1.0):
	get:
		if collision_shape and collision_child:
			return area_size
		else:
			return area_size
	set(value):
		if collision_shape and collision_child:
			collision_shape.size = value
			collision_child.position.y = value.y / 2
		area_size = value
@export var area_rotation: Vector3:
	get:
		return area_rotation
	set(value):
		rotation = area_rotation

var collision_child: CollisionShape3D
var collision_shape: BoxShape3D

func _ready() -> void:
	collision_layer = 2

func _enter_tree() -> void:
	if Engine.is_editor_hint and get_child_count(true) == 0:
		collision_child = CollisionShape3D.new()
		collision_shape = BoxShape3D.new()
		collision_child.set_name("CollisionShape3D")
		collision_child.shape = collision_shape
		collision_shape.size = area_size
		collision_child.position.y = area_size.y / 2
		
		add_child(collision_child)
		collision_child.set_owner(owner)
	elif Engine.is_editor_hint and get_child_count(true) > 0:
		for child in get_children():
			if child == get_child(0):
				collision_child = get_child(0)
				collision_child.set_name("CollisionShape3D")
				collision_shape = get_child(0).shape
			else:
				child.queue_free()
		
