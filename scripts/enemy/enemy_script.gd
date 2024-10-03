extends CharacterBody3D
class_name Enemy

@export var enemy_name: String
@export var enemy_health: int
@export var enemy_speed: float = 3.0

@export var nav_agent: NavigationAgent3D
@export var state_machine: StateMachine
