extends State
class_name EnemyState

var player: Player = PlayerManager.player_ref

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func enter(previous_state_name: String, data: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass
