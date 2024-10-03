extends EnemyState

@onready var enemy: TestEnemy = owner
@onready var timer: Timer = $StartleTimer

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	enemy.current_target = player.position
	if enemy.position.distance_to(player.position) < 5:
		finished.emit("ChaseState")
	elif enemy.position.distance_to(player.position) > 10:
		finished.emit("IdleState")

func enter(previous_state_name: String, data: Dictionary = {}) -> void:
	enemy.enemy_speed = 0.0
	timer.start()

func exit() -> void:
	timer.stop()

func _on_startle_timer_timeout() -> void:
	finished.emit("ChaseState")
