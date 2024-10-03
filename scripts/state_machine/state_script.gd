extends Node
class_name State

signal finished(next_state_name: String, data: Dictionary)

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func enter(previous_state_name: String, data: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass
