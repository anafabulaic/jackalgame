extends Node
class_name StateMachine

@export var state_machine_name: String
@export var default_state: State

@onready var current_state: State = default_state
var previous_state: State

var states: Dictionary

func _ready() -> void:
	if state_machine_name == null:
		state_machine_name = name
		push_warning("Couldn't find State Machine name, setting to Node name")
		
	if get_child_count() > 0:
		for state in get_children():
			states[state.name] = state
			state.finished.connect(transition_to_state)
	else:
		push_error("State Machine ", state_machine_name, " initialized with no states.")
		return
		
	if default_state == null:
		push_error("No default state set for State Machine ", state_machine_name)
		return
	else:
		set_state(default_state.name)
		
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
	
func set_state(desired_state_name: String, data: Dictionary = {}) -> void:
	if states.size() < 1:
		push_warning("Could not set state ", desired_state_name, " because State Machine ", state_machine_name, " is empty.")
		return
	elif states[desired_state_name] == null:
		push_warning("Tried setting non-existent state ", desired_state_name, " in State Machine ", state_machine_name)
		return
	elif states.size() == 1:
		push_warning("Tried setting a state in State Machine ", state_machine_name, ", which only has one state.")
		return
	
	print("Set state to ", desired_state_name)
	previous_state = current_state
	current_state.exit()
	current_state = states[desired_state_name]
	current_state.enter(previous_state.name, data)

func transition_to_state(desired_state_name: String, data: Dictionary = {}) -> void:
	set_state(desired_state_name, data)
