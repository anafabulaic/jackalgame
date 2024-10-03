extends EnemyState

@onready var enemy: TestEnemy = owner

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	enemy.current_target = player.position
	if enemy.position.distance_to(player.position) < 2.0:
		finished.emit("AttackingState")

func enter(previous_state_name: String, data: Dictionary = {}) -> void:
	enemy.enemy_speed = 2.5

func exit() -> void:
	pass
