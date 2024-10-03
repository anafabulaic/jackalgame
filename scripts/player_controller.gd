extends CharacterBody3D
class_name Player

@export var speed: float = 4
@export var turning_speed: float = 3

@export var area_collider: Area3D
var current_area_colliding: Area3D

var target_velocity: Vector3 = Vector3.ZERO

var quickturn_on_cooldown: bool = false

var aiming: bool = false
var focus: float = 20.0

@onready var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.player_ref = self

func _physics_process(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	if PlayerManager.player_state != PlayerManager.PLAYER_READY:
		return
		
	if Input.is_action_pressed("moveright"):
		rotation.y -= turning_speed * delta
	if Input.is_action_pressed("moveleft"):
		rotation.y += turning_speed * delta
	if Input.is_action_pressed("movebackward"):
		if Input.is_action_just_pressed("movesprint") and quickturn_on_cooldown == false:
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(self, "rotation:y", rotation.y + deg_to_rad(180), 0.3)
			change_focus(30.0)
			quickturn_on_cooldown = true
			await get_tree().create_timer(0.4).timeout
			quickturn_on_cooldown = false
		else:
			speed = 1
			direction.x -= 1
	if Input.is_action_pressed("moveforward"):
		speed = 2
		direction.x += 1
		
	if Input.is_action_pressed("weapon_aim"):
		turning_speed = 0.25
		speed = 1
		
		aiming = true
		
		var look_pos = position + Vector3(0,2,0)
		var look_pos_end = jitter_position_3D(look_pos + (basis.x * 50.0), focus * 0.02)
		
		var query = PhysicsRayQueryParameters3D.create(look_pos, look_pos_end)
		query.collide_with_areas = true
		query.collision_mask = 0b00000000_00000000_00000000_00000001
		var result = space_state.intersect_ray(query)
		
		Global.drawing_canvas.line_start = Global.current_camera.unproject_position(look_pos)
		
		if result:
			var dist = look_pos.distance_to(result.position)
			dist = clampf(dist, 0.0, 5.0)
			dist = remap(dist, 0.0, 5.0, 0.01, 5.0)
			
			var jittered_position = jitter_position(Global.current_camera.unproject_position(result.position), focus * 0.5)
			
			Global.drawing_canvas.line_stop = Global.current_camera.unproject_position(result.position)
			Global.drawing_canvas.reticle_pos = jittered_position
			
			if velocity.length() > 0.0:
				change_focus(0.1 * dist)
			if Input.is_action_pressed("moveright") or Input.is_action_pressed("moveleft"):
				change_focus(0.1 * dist)
			
			change_focus(-0.6 + (dist * 0.025))
			
			Global.drawing_canvas.draw_enabled = true
			Global.drawing_canvas.distance = focus
					
	elif Input.is_action_pressed("movesprint") and Input.is_action_pressed("moveforward"):
		turning_speed = 2
		speed = 4
		
		Global.drawing_canvas.draw_enabled = false
		aiming = false
		change_focus(0.5)
	else:
		turning_speed = 4
		
		Global.drawing_canvas.draw_enabled = false
		aiming = false
		change_focus(1.0)
		
	
		
	target_velocity = direction.rotated(Vector3(0,1,0), rotation.y) * speed
	if not is_on_floor():
		target_velocity -= Vector3(0,1,0) * 9.8
		
	if get_last_slide_collision():
		var col = get_last_slide_collision()
		
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_impulse(-col.get_normal() * 50 * delta, col.get_position() - col.get_collider().global_position)
		
	velocity = target_velocity
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if PlayerManager.player_state == PlayerManager.PLAYER_READY and Input.is_action_just_pressed("weapon_fire"):
		if Input.is_action_pressed("weapon_aim"):
			var look_pos = position + Vector3(0,2,0)
			var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(look_pos, look_pos + (basis.x * 50.0))
			query.collide_with_areas = true
			var result: Dictionary = space_state.intersect_ray(query)
			Global.drawing_canvas.flash()
			if result["collider"] is Enemy:
				var damage: float = remap(focus, 1.0, 20.0, 10.0, 5.0)
				damage = clampf(damage, 5.0, 10.0)
				result["collider"].hit(damage)
			change_focus(30.0)
		else:
			interact()

func interact() -> void:
	if current_area_colliding and current_area_colliding.has_method("do_interact"):
		current_area_colliding.do_interact()

func _on_area_3d_area_entered(area: Area3D) -> void:
	current_area_colliding = area

func _on_area_3d_area_exited(area: Area3D) -> void:
	if current_area_colliding == area:
		current_area_colliding = null

func change_focus(focus_target: float) -> void:
	focus += focus_target
	focus = clampf(focus, 1.0, 20.0)
	Global.drawing_canvas.distance = focus

func jitter_position(pos: Vector2, intensity: float) -> Vector2:
	var rand: Vector2 = pos + Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
	rand.x = clampf(rand.x, pos.x - intensity, pos.x + intensity)
	rand.y = clampf(rand.y, pos.y - intensity, pos.y + intensity)
	return rand
	
func jitter_position_3D(pos: Vector3, intensity: float) -> Vector3:
	var rand: Vector3 = pos + Vector3(randf_range(-intensity, intensity), randf_range(-intensity, intensity), randf_range(-intensity, intensity))
	rand.x = clampf(rand.x, pos.x - intensity, pos.x + intensity)
	rand.y = clampf(rand.y, pos.y - intensity, pos.y + intensity)
	rand.z = clampf(rand.z, pos.z - intensity, pos.z + intensity)
	return rand

func create_aim() -> void:
	pass
