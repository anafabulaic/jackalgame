extends EnemyState

@onready var enemy: TestEnemy = owner
@onready var timer: Timer = $IdleTimer

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if enemy.position.distance_to(player.position) < 10:
		finished.emit("StartledState")

func enter(previous_state_name: String, data: Dictionary = {}) -> void:
	enemy.enemy_speed = 1.0
	await get_tree().process_frame
	get_random_pos()
	timer.start(randf_range(5.0,10.0))

func exit() -> void:
	timer.stop()

func _on_idle_timer_timeout() -> void:
	get_random_pos()

func get_random_pos() -> void:
	var random_location: Vector3 = enemy.global_position + Vector3(randf_range(-5.0,5.0), 0, randf_range(-5.0,5.0))
	random_location = NavigationServer3D.map_get_closest_point(enemy.nav_agent.get_navigation_map(), random_location)
	print("Obtained random position at ", random_location)
	
	enemy.current_look_target = random_location
	enemy.current_target = random_location
