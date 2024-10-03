extends EnemyState

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func enter(previous_state_name: String, data: Dictionary = {}) -> void:
	await Global.wait(1.0)
	finished.emit("ChaseState")

func exit() -> void:
	pass
