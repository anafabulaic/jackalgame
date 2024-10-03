extends CharacterBody3D


var speed: int = 4
var turning_speed: int = 3
var target_velocity: Vector3 = Vector3.ZERO
var dir: Vector3 = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	# We create a local variable to store the input direction.
	var direction: Vector3 = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("moveright"):
		rotation.y -= turning_speed * delta
	if Input.is_action_pressed("moveleft"):
		rotation.y += turning_speed * delta
	if Input.is_action_pressed("movebackward"):
		if Input.is_action_just_pressed("movesprint"):
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(self, "rotation:y", rotation.y + deg_to_rad(180), 0.3)
		else:
			direction.x -= 1
	if Input.is_action_pressed("moveforward"):
		direction.x += 1
		
	if Input.is_action_pressed("weapon_aim"):
		turning_speed = 1
		speed = 0
	elif Input.is_action_pressed("movesprint"):
		turning_speed = 3
		speed = 4
	else:
		turning_speed = 3
		speed = 2
		
	target_velocity = direction.rotated(Vector3(0,1,0), rotation.y) * speed
		
	velocity = target_velocity
	move_and_slide()
		
#func _process(delta: float) -> void:
	#if Input.is_action_pressed("moveforward"):
		#position += transform.basis.z * delta * speed
	#elif Input.is_action_pressed("movebackward"):
		#position += -transform.basis.z * delta * speed
	#if Input.is_action_pressed("moveleft"):
		#rotation += Vector3(0,1,0) * delta * 2
	#if Input.is_action_pressed("moveright"):
		#rotation += Vector3(0,-1,0) * delta * 2
