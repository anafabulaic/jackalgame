extends Enemy
class_name TestEnemy

var current_target: Vector3 = Vector3.ZERO
var current_look_target: Vector3
var reached_target: bool = false

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var current_location: Vector3 = global_transform.origin
	var next_location: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = (next_location - current_location).normalized() * enemy_speed
	
	update_target_location(current_target)
	nav_agent.set_velocity(new_velocity)
	
	if current_look_target and nav_agent.distance_to_target() > 1.0:
		enemy_look_at(next_location)
		reached_target = false
	elif nav_agent.distance_to_target() <= 1.0:
		reached_target = true
	

func update_target_location(target: Vector3) -> void:
	nav_agent.target_position = target

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, .2)
	if reached_target == false:
		move_and_slide()

func enemy_look_at(target: Vector3) -> void:
	var target_vector: Vector3 = global_position.direction_to(target)
	if target_vector == Vector3(0,0,0):
		target_vector += Vector3(0.001,0.001,0.001)
	var target_basis: Basis = Basis.looking_at(target_vector)

	basis = basis.slerp(target_basis, 0.05)
	rotation.x = 0.0
	rotation.z = 0.0

func hit(damage: int) -> void:
	if enemy_health <= damage:
		queue_free()
	else:
		enemy_health -= damage
		state_machine.set_state("ChaseState")
	
func damage_flash() -> void:
	pass
