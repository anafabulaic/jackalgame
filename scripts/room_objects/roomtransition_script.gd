extends Node
class_name RoomTransition

@export var room_transition_length: float
@export var camera: Camera3D
@export var animation_player: AnimationPlayer

signal transition_midpoint
signal transition_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Entered scene")
	animation_player.current_animation = "transition_enter"

func destroy() -> void:
	queue_free()
	
func _input(event: InputEvent) -> void:
	if PlayerManager.player_state == PlayerManager.PLAYER_IN_SCENE_TRANSITION and Input.is_anything_pressed():
		if animation_player.current_animation != "transition_exit":
			transition_midpoint.emit()
		transition_finished.emit()
		destroy()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "transition_enter":
		print("Finished Enter")
		animation_player.current_animation = "transition_exit"
		transition_midpoint.emit()
	if anim_name == "transition_exit":
		print("Finished Exit")
		transition_finished.emit()
	
